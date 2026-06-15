-- ============================================================
-- BillShield double-entry invariants
-- Apply with: npm run billshield:invariants
--   (npx prisma db execute --file prisma/sql/billshield_invariants.sql)
-- Idempotent: safe to re-run after every `prisma db push`.
-- ============================================================

-- ------------------------------------------------------------
-- 1. Every voucher line is strictly one-sided (Dr XOR Cr)
-- ------------------------------------------------------------
ALTER TABLE "VoucherLine" DROP CONSTRAINT IF EXISTS voucher_line_one_sided;
ALTER TABLE "VoucherLine" ADD CONSTRAINT voucher_line_one_sided
  CHECK ((debit > 0 AND credit = 0) OR (credit > 0 AND debit = 0));

-- ------------------------------------------------------------
-- 2. Balanced voucher: at commit, every POSTED/REVERSED voucher
--    must have SUM(debit) = SUM(credit) and at least 2 lines.
--    Deferred constraint trigger so multi-statement inserts work.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION billshield_check_voucher_balanced() RETURNS trigger AS $$
DECLARE
  v_id TEXT;
  v_status TEXT;
  v_lines INT;
  v_dr NUMERIC;
  v_cr NUMERIC;
BEGIN
  IF TG_TABLE_NAME = 'Voucher' THEN
    v_id := NEW.id;
  ELSE
    v_id := COALESCE(NEW."voucherId", OLD."voucherId");
  END IF;

  SELECT status INTO v_status FROM "Voucher" WHERE id = v_id;
  IF v_status IS NULL OR v_status = 'DRAFT' THEN
    RETURN NULL;
  END IF;

  SELECT COUNT(*), COALESCE(SUM(debit), 0), COALESCE(SUM(credit), 0)
    INTO v_lines, v_dr, v_cr
    FROM "VoucherLine" WHERE "voucherId" = v_id;

  IF v_lines < 2 THEN
    RAISE EXCEPTION 'BillShield: voucher % must have at least 2 lines', v_id;
  END IF;
  IF v_dr <> v_cr THEN
    RAISE EXCEPTION 'BillShield: voucher % is unbalanced (Dr % <> Cr %)', v_id, v_dr, v_cr;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS billshield_voucher_balanced ON "Voucher";
CREATE CONSTRAINT TRIGGER billshield_voucher_balanced
  AFTER INSERT OR UPDATE OF status ON "Voucher"
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION billshield_check_voucher_balanced();

DROP TRIGGER IF EXISTS billshield_voucher_line_balanced ON "VoucherLine";
CREATE CONSTRAINT TRIGGER billshield_voucher_line_balanced
  AFTER INSERT OR UPDATE OR DELETE ON "VoucherLine"
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION billshield_check_voucher_balanced();

-- ------------------------------------------------------------
-- 3. Posted vouchers are immutable.
--    Allowed transitions: DRAFT -> anything; POSTED -> REVERSED
--    (status + updatedAt only). Everything else is rejected.
--    Lines of a non-DRAFT voucher cannot be touched.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION billshield_voucher_immutable() RETURNS trigger AS $$
BEGIN
  IF OLD.status = 'DRAFT' THEN
    RETURN NEW;
  END IF;

  IF TG_OP = 'DELETE' THEN
    RAISE EXCEPTION 'BillShield: voucher % is %; posted vouchers cannot be deleted — post a reversal instead', OLD.id, OLD.status;
  END IF;

  IF OLD.status = 'POSTED' AND NEW.status = 'REVERSED'
     AND NEW."companyId" = OLD."companyId"
     AND NEW."fiscalYearId" = OLD."fiscalYearId"
     AND NEW."voucherTypeId" = OLD."voucherTypeId"
     AND NEW."voucherNo" IS NOT DISTINCT FROM OLD."voucherNo"
     AND NEW."voucherDate" = OLD."voucherDate"
     AND NEW.narration IS NOT DISTINCT FROM OLD.narration
     AND NEW."partyId" IS NOT DISTINCT FROM OLD."partyId"
     AND NEW."reversalOfId" IS NOT DISTINCT FROM OLD."reversalOfId"
     AND NEW."postedAt" IS NOT DISTINCT FROM OLD."postedAt"
     AND NEW."createdById" = OLD."createdById"
  THEN
    RETURN NEW;
  END IF;

  RAISE EXCEPTION 'BillShield: voucher % is %; posted vouchers are immutable — post a reversal instead', OLD.id, OLD.status;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS billshield_voucher_immutable ON "Voucher";
CREATE TRIGGER billshield_voucher_immutable
  BEFORE UPDATE OR DELETE ON "Voucher"
  FOR EACH ROW EXECUTE FUNCTION billshield_voucher_immutable();

CREATE OR REPLACE FUNCTION billshield_voucher_line_immutable() RETURNS trigger AS $$
DECLARE
  v_status TEXT;
BEGIN
  SELECT status INTO v_status FROM "Voucher" WHERE id = COALESCE(NEW."voucherId", OLD."voucherId");
  -- NULL: voucher row already deleted (cascade) — only possible for DRAFTs
  IF v_status IS NULL OR v_status = 'DRAFT' THEN
    RETURN COALESCE(NEW, OLD);
  END IF;
  RAISE EXCEPTION 'BillShield: lines of % voucher % cannot be modified', v_status, COALESCE(NEW."voucherId", OLD."voucherId");
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS billshield_voucher_line_immutable ON "VoucherLine";
CREATE TRIGGER billshield_voucher_line_immutable
  BEFORE UPDATE OR DELETE ON "VoucherLine"
  FOR EACH ROW EXECUTE FUNCTION billshield_voucher_line_immutable();

-- Also block adding lines to an already-posted voucher.
-- (The service always creates lines while the voucher is DRAFT,
--  then flips status to POSTED in the same transaction.)
CREATE OR REPLACE FUNCTION billshield_voucher_line_insert_guard() RETURNS trigger AS $$
DECLARE
  v_status TEXT;
BEGIN
  SELECT status INTO v_status FROM "Voucher" WHERE id = NEW."voucherId";
  IF v_status IS NOT NULL AND v_status <> 'DRAFT' THEN
    RAISE EXCEPTION 'BillShield: cannot add lines to % voucher %', v_status, NEW."voucherId";
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS billshield_voucher_line_insert_guard ON "VoucherLine";
CREATE TRIGGER billshield_voucher_line_insert_guard
  BEFORE INSERT ON "VoucherLine"
  FOR EACH ROW EXECUTE FUNCTION billshield_voucher_line_insert_guard();

-- ------------------------------------------------------------
-- 4. No posting into a closed fiscal year
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION billshield_check_fy_open() RETURNS trigger AS $$
DECLARE
  v_closed BOOLEAN;
  v_start TIMESTAMP;
  v_end TIMESTAMP;
BEGIN
  IF NEW.status = 'DRAFT' THEN
    RETURN NEW;
  END IF;
  SELECT "isClosed", "startDate", "endDate" INTO v_closed, v_start, v_end
    FROM "FiscalYear" WHERE id = NEW."fiscalYearId";
  IF v_closed THEN
    RAISE EXCEPTION 'BillShield: fiscal year % is closed; cannot post voucher', NEW."fiscalYearId";
  END IF;
  IF NEW."voucherDate" < v_start OR NEW."voucherDate" > v_end THEN
    RAISE EXCEPTION 'BillShield: voucher date % outside fiscal year %', NEW."voucherDate", NEW."fiscalYearId";
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS billshield_voucher_fy_open ON "Voucher";
CREATE TRIGGER billshield_voucher_fy_open
  BEFORE INSERT OR UPDATE OF status ON "Voucher"
  FOR EACH ROW EXECUTE FUNCTION billshield_check_fy_open();

-- ------------------------------------------------------------
-- 5. Account group tree: no cycles, child nature = parent nature,
--    same company, and materialized path maintenance.
--    Path = slugified names joined by '/', e.g.
--    'current-assets/sundry-debtors/north-region'
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION billshield_slugify(name TEXT) RETURNS TEXT AS $$
  SELECT trim(both '-' from regexp_replace(lower(name), '[^a-z0-9]+', '-', 'g'));
$$ LANGUAGE sql IMMUTABLE;

CREATE OR REPLACE FUNCTION billshield_group_tree_guard() RETURNS trigger AS $$
DECLARE
  parent RECORD;
BEGIN
  IF NEW."parentGroupId" IS NULL THEN
    NEW.path := billshield_slugify(NEW.name);
  ELSE
    SELECT * INTO parent FROM "AccountGroup" WHERE id = NEW."parentGroupId";
    IF parent IS NULL THEN
      RAISE EXCEPTION 'BillShield: parent group % not found', NEW."parentGroupId";
    END IF;
    IF parent."companyId" <> NEW."companyId" THEN
      RAISE EXCEPTION 'BillShield: parent group belongs to a different company';
    END IF;
    IF parent.nature <> NEW.nature THEN
      RAISE EXCEPTION 'BillShield: group nature (%) must match parent nature (%)', NEW.nature, parent.nature;
    END IF;
    IF NEW."parentGroupId" = NEW.id THEN
      RAISE EXCEPTION 'BillShield: a group cannot be its own parent';
    END IF;
    -- cycle check: walk up from the new parent
    IF TG_OP = 'UPDATE' AND EXISTS (
      WITH RECURSIVE up AS (
        SELECT id, "parentGroupId" FROM "AccountGroup" WHERE id = NEW."parentGroupId"
        UNION ALL
        SELECT g.id, g."parentGroupId" FROM "AccountGroup" g JOIN up ON g.id = up."parentGroupId"
      ) SELECT 1 FROM up WHERE id = NEW.id
    ) THEN
      RAISE EXCEPTION 'BillShield: re-parenting group % under % would create a cycle', NEW.id, NEW."parentGroupId";
    END IF;
    NEW.path := parent.path || '/' || billshield_slugify(NEW.name);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS billshield_group_tree_guard ON "AccountGroup";
CREATE TRIGGER billshield_group_tree_guard
  BEFORE INSERT OR UPDATE OF "parentGroupId", name, nature ON "AccountGroup"
  FOR EACH ROW EXECUTE FUNCTION billshield_group_tree_guard();

-- Cascade path rewrite to descendants on rename / re-parent
CREATE OR REPLACE FUNCTION billshield_group_path_cascade() RETURNS trigger AS $$
BEGIN
  IF NEW.path <> OLD.path THEN
    UPDATE "AccountGroup"
      SET path = NEW.path || substr(path, length(OLD.path) + 1)
      WHERE "companyId" = NEW."companyId"
        AND path LIKE OLD.path || '/%'
        AND id <> NEW.id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS billshield_group_path_cascade ON "AccountGroup";
CREATE TRIGGER billshield_group_path_cascade
  AFTER UPDATE OF path ON "AccountGroup"
  FOR EACH ROW EXECUTE FUNCTION billshield_group_path_cascade();

-- ------------------------------------------------------------
-- 6. Voucher lines must stay within the voucher's company
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION billshield_line_company_guard() RETURNS trigger AS $$
DECLARE
  v_company TEXT;
  l_company TEXT;
BEGIN
  SELECT "companyId" INTO v_company FROM "Voucher" WHERE id = NEW."voucherId";
  SELECT "companyId" INTO l_company FROM "LedgerAccount" WHERE id = NEW."ledgerId";
  IF v_company <> l_company THEN
    RAISE EXCEPTION 'BillShield: ledger % belongs to a different company than voucher %', NEW."ledgerId", NEW."voucherId";
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS billshield_line_company_guard ON "VoucherLine";
CREATE TRIGGER billshield_line_company_guard
  BEFORE INSERT OR UPDATE OF "ledgerId" ON "VoucherLine"
  FOR EACH ROW EXECUTE FUNCTION billshield_line_company_guard();

-- ------------------------------------------------------------
-- 7. Extra performance indexes (beyond Prisma's)
-- ------------------------------------------------------------
CREATE INDEX IF NOT EXISTS billshield_voucher_posted_by_date
  ON "Voucher" ("companyId", "voucherDate")
  WHERE status = 'POSTED';

CREATE INDEX IF NOT EXISTS billshield_line_ledger_only
  ON "VoucherLine" ("ledgerId");
