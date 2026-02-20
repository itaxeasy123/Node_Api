/*
  Warnings:

  - The values [loansAndLiabilities] on the enum `LedgerType` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "LedgerType_new" AS ENUM ('bank', 'cash', 'purchase', 'sales', 'directExpense', 'indirectExpense', 'directIncome', 'indirectIncome', 'fixedAssets', 'currentAssets', 'loansAndLiabilitieslw', 'accountsReceivable', 'accountsPayable');
ALTER TABLE "Ledger" ALTER COLUMN "ledgerType" TYPE "LedgerType_new" USING ("ledgerType"::text::"LedgerType_new");
ALTER TYPE "LedgerType" RENAME TO "LedgerType_old";
ALTER TYPE "LedgerType_new" RENAME TO "LedgerType";
DROP TYPE "LedgerType_old";
COMMIT;

-- AlterTable
ALTER TABLE "Ledger" ALTER COLUMN "year" DROP DEFAULT,
ALTER COLUMN "month" DROP DEFAULT;

-- AlterTable
ALTER TABLE "Post" ALTER COLUMN "imageUrl" DROP NOT NULL;
