--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: BankAccountType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."BankAccountType" AS ENUM (
    'savings',
    'current',
    'nri',
    'fcnr',
    'rd',
    'fd',
    'salary'
);


ALTER TYPE public."BankAccountType" OWNER TO postgres;

--
-- Name: CurrencyType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."CurrencyType" AS ENUM (
    'INR',
    'USD',
    'EUR',
    'RUB'
);


ALTER TYPE public."CurrencyType" OWNER TO postgres;

--
-- Name: DocumentType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."DocumentType" AS ENUM (
    'pdf',
    'image',
    'other'
);


ALTER TYPE public."DocumentType" OWNER TO postgres;

--
-- Name: InvoiceStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."InvoiceStatus" AS ENUM (
    'unpaid',
    'paid',
    'overdue'
);


ALTER TYPE public."InvoiceStatus" OWNER TO postgres;

--
-- Name: InvoiceType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."InvoiceType" AS ENUM (
    'sales',
    'purchase',
    'sales_return',
    'purchase_return'
);


ALTER TYPE public."InvoiceType" OWNER TO postgres;

--
-- Name: ItemUnit; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ItemUnit" AS ENUM (
    'pieces',
    'grams',
    'kilograms',
    'liters',
    'milliliters',
    'meters',
    'centimeters',
    'inches',
    'feet',
    'squareMeters',
    'squareFeet',
    'cubicMeters',
    'cubicFeet',
    'dozen',
    'pack',
    'carton',
    'box',
    'roll',
    'bundle',
    'pair',
    'set'
);


ALTER TYPE public."ItemUnit" OWNER TO postgres;

--
-- Name: LedgerType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."LedgerType" AS ENUM (
    'bank',
    'cash',
    'purchase',
    'sales',
    'directExpense',
    'indirectExpense',
    'directIncome',
    'indirectIncome',
    'fixedAssets',
    'currentAssets',
    'loansAndLiabilitieslw',
    'accountsReceivable',
    'accountsPayable'
);


ALTER TYPE public."LedgerType" OWNER TO postgres;

--
-- Name: LoanStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."LoanStatus" AS ENUM (
    'pending',
    'processing',
    'review',
    'accepted',
    'rejected'
);


ALTER TYPE public."LoanStatus" OWNER TO postgres;

--
-- Name: LoanType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."LoanType" AS ENUM (
    'personal',
    'education',
    'home',
    'business',
    'car',
    'property'
);


ALTER TYPE public."LoanType" OWNER TO postgres;

--
-- Name: ModeOfPayment; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."ModeOfPayment" AS ENUM (
    'cash',
    'bank',
    'upi',
    'credit'
);


ALTER TYPE public."ModeOfPayment" OWNER TO postgres;

--
-- Name: NAME; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."NAME" AS ENUM (
    'sales',
    'cash',
    'Rent',
    'Expense'
);


ALTER TYPE public."NAME" OWNER TO postgres;

--
-- Name: Nationality; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."Nationality" AS ENUM (
    'resident',
    'nri',
    'foreign'
);


ALTER TYPE public."Nationality" OWNER TO postgres;

--
-- Name: OrderStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."OrderStatus" AS ENUM (
    'initiated',
    'pending',
    'success',
    'failure',
    'usercancelled',
    'dropped',
    'bounced'
);


ALTER TYPE public."OrderStatus" OWNER TO postgres;

--
-- Name: PartyType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."PartyType" AS ENUM (
    'customer',
    'supplier'
);


ALTER TYPE public."PartyType" OWNER TO postgres;

--
-- Name: PaymentStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."PaymentStatus" AS ENUM (
    'created',
    'success',
    'failed'
);


ALTER TYPE public."PaymentStatus" OWNER TO postgres;

--
-- Name: StartupCategory; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."StartupCategory" AS ENUM (
    'registration',
    'companyRegistration',
    'returns',
    'audits'
);


ALTER TYPE public."StartupCategory" OWNER TO postgres;

--
-- Name: SubscriptionStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."SubscriptionStatus" AS ENUM (
    'initiated',
    'pending',
    'success',
    'failure',
    'usercancelled',
    'dropped',
    'bounced'
);


ALTER TYPE public."SubscriptionStatus" OWNER TO postgres;

--
-- Name: SubscriptionsDuration; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."SubscriptionsDuration" AS ENUM (
    'monthly',
    'quarterly',
    'halfYealy',
    'yearly'
);


ALTER TYPE public."SubscriptionsDuration" OWNER TO postgres;

--
-- Name: TransactionType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."TransactionType" AS ENUM (
    'credit',
    'debit'
);


ALTER TYPE public."TransactionType" OWNER TO postgres;

--
-- Name: Under; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."Under" AS ENUM (
    'sales',
    'Revenue'
);


ALTER TYPE public."Under" OWNER TO postgres;

--
-- Name: UserGender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."UserGender" AS ENUM (
    'male',
    'female',
    'other'
);


ALTER TYPE public."UserGender" OWNER TO postgres;

--
-- Name: UserType; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."UserType" AS ENUM (
    'admin',
    'normal',
    'agent',
    'superadmin'
);


ALTER TYPE public."UserType" OWNER TO postgres;

--
-- Name: paymentMethod; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."paymentMethod" AS ENUM (
    'cash',
    'creditcard',
    'upi',
    'netbanking',
    'cheque'
);


ALTER TYPE public."paymentMethod" OWNER TO postgres;

--
-- Name: paymentStatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public."paymentStatus" AS ENUM (
    'paid',
    'unpaid',
    'overdue'
);


ALTER TYPE public."paymentStatus" OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: About; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."About" (
    id text NOT NULL,
    name text NOT NULL,
    "position" text NOT NULL,
    image text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public."About" OWNER TO postgres;

--
-- Name: Account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Account" (
    id text NOT NULL,
    "accountName" text NOT NULL,
    "totalDebit" numeric(65,30) DEFAULT 0.0 NOT NULL,
    "totalCredit" numeric(65,30) DEFAULT 0.0 NOT NULL,
    "debitBalance" numeric(65,30) DEFAULT 0.0 NOT NULL,
    "creditBalance" numeric(65,30) DEFAULT 0.0 NOT NULL,
    date timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "userId" integer NOT NULL
);


ALTER TABLE public."Account" OWNER TO postgres;

--
-- Name: Agent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Agent" (
    id text NOT NULL,
    "userId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Agent" OWNER TO postgres;

--
-- Name: ApiService; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ApiService" (
    id text NOT NULL,
    title text NOT NULL,
    overview text NOT NULL,
    price double precision NOT NULL,
    upcoming boolean NOT NULL,
    endpoint jsonb,
    "bodyParams" jsonb,
    response jsonb,
    "responseJSON" jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    category text NOT NULL
);


ALTER TABLE public."ApiService" OWNER TO postgres;

--
-- Name: BankDetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BankDetails" (
    id text NOT NULL,
    "accountHolderName" text NOT NULL,
    "bankName" text NOT NULL,
    "bankAccountNo" text NOT NULL,
    "bankIfsc" text NOT NULL,
    "bankBranch" text NOT NULL,
    "bankAccountType" public."BankAccountType" NOT NULL,
    "userId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."BankDetails" OWNER TO postgres;

--
-- Name: Billpayable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Billpayable" (
    id integer NOT NULL,
    "supplierName" text NOT NULL,
    "supplierAddress" text NOT NULL,
    contact text NOT NULL,
    "billDate" text NOT NULL,
    "dueDate" text NOT NULL,
    "billAmount" text NOT NULL,
    "billNumber" text NOT NULL,
    "billDiscription" text NOT NULL,
    "paymentMethod" public."paymentMethod" DEFAULT 'cash'::public."paymentMethod" NOT NULL,
    "transactionId" text,
    "paymentDate" text NOT NULL,
    "paymentAmount" text NOT NULL,
    tax text NOT NULL,
    comment text,
    "invoiceNumber" text
);


ALTER TABLE public."Billpayable" OWNER TO postgres;

--
-- Name: Billpayable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Billpayable_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Billpayable_id_seq" OWNER TO postgres;

--
-- Name: Billpayable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Billpayable_id_seq" OWNED BY public."Billpayable".id;


--
-- Name: Billrecieve; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Billrecieve" (
    id integer NOT NULL,
    "billNumber" text NOT NULL,
    amount text NOT NULL,
    tax text NOT NULL,
    "customerName" text NOT NULL,
    "customerAddress" text NOT NULL,
    contact text NOT NULL,
    "itemQuantity" text NOT NULL,
    "itemPrice" text NOT NULL,
    "itemDescription" text NOT NULL,
    "paymentStatus" public."paymentStatus" DEFAULT 'unpaid'::public."paymentStatus" NOT NULL,
    "paymentMethod" public."paymentMethod" DEFAULT 'cash'::public."paymentMethod" NOT NULL,
    "dueDate" text NOT NULL,
    comment text
);


ALTER TABLE public."Billrecieve" OWNER TO postgres;

--
-- Name: Billrecieve_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Billrecieve_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Billrecieve_id_seq" OWNER TO postgres;

--
-- Name: Billrecieve_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Billrecieve_id_seq" OWNED BY public."Billrecieve".id;


--
-- Name: BusinessProfile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."BusinessProfile" (
    id integer NOT NULL,
    "businessName" text NOT NULL,
    pan text,
    tan text,
    taxpayer_type text,
    msme_number text,
    status text,
    ctb text,
    gstin text,
    statecode text,
    street text,
    city text,
    dst text,
    stcd text,
    landmark text,
    "bankName" text,
    "bankAccountNo" text,
    "bankIfsc" text,
    "bankBranch" text,
    "userId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "isAddressVerified" boolean,
    "isBusinessNameVerified" boolean,
    "isGstinVerified" boolean,
    "isPanVerified" boolean,
    "isStateVerified" boolean,
    pincode text,
    state text
);


ALTER TABLE public."BusinessProfile" OWNER TO postgres;

--
-- Name: BusinessProfile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."BusinessProfile_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."BusinessProfile_id_seq" OWNER TO postgres;

--
-- Name: BusinessProfile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."BusinessProfile_id_seq" OWNED BY public."BusinessProfile".id;


--
-- Name: Career; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Career" (
    id integer NOT NULL,
    name text NOT NULL,
    address text NOT NULL,
    pin text NOT NULL,
    email text NOT NULL,
    mobile text NOT NULL,
    skills text NOT NULL,
    gender public."UserGender" NOT NULL,
    cv text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Career" OWNER TO postgres;

--
-- Name: Career_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Career_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Career_id_seq" OWNER TO postgres;

--
-- Name: Career_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Career_id_seq" OWNED BY public."Career".id;


--
-- Name: Cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Cart" (
    id text NOT NULL,
    "userId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    category text
);


ALTER TABLE public."Cart" OWNER TO postgres;

--
-- Name: Category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Category" (
    id text NOT NULL,
    "categoryName" text NOT NULL,
    "userId" integer NOT NULL
);


ALTER TABLE public."Category" OWNER TO postgres;

--
-- Name: Client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Client" (
    id text NOT NULL,
    "userId" integer NOT NULL,
    "agentId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Client" OWNER TO postgres;

--
-- Name: ContactUs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ContactUs" (
    id integer NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    message text NOT NULL
);


ALTER TABLE public."ContactUs" OWNER TO postgres;

--
-- Name: ContactUs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ContactUs_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ContactUs_id_seq" OWNER TO postgres;

--
-- Name: ContactUs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ContactUs_id_seq" OWNED BY public."ContactUs".id;


--
-- Name: CostInflationIndex; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CostInflationIndex" (
    id text NOT NULL,
    "financialYear" text NOT NULL,
    "costInflationIndex" integer NOT NULL
);


ALTER TABLE public."CostInflationIndex" OWNER TO postgres;

--
-- Name: CostInflationList; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CostInflationList" (
    id text NOT NULL,
    "financeAct" text NOT NULL,
    "listName" text NOT NULL
);


ALTER TABLE public."CostInflationList" OWNER TO postgres;

--
-- Name: CountryCode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CountryCode" (
    id text NOT NULL,
    "countryCode" text NOT NULL,
    "countryName" text NOT NULL
);


ALTER TABLE public."CountryCode" OWNER TO postgres;

--
-- Name: CountryCodeList; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CountryCodeList" (
    id text NOT NULL,
    "assessYear" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."CountryCodeList" OWNER TO postgres;

--
-- Name: DepreciationTable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."DepreciationTable" (
    id integer NOT NULL,
    "assetType" text NOT NULL,
    "depreciationRate" double precision NOT NULL
);


ALTER TABLE public."DepreciationTable" OWNER TO postgres;

--
-- Name: DepreciationTable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."DepreciationTable_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."DepreciationTable_id_seq" OWNER TO postgres;

--
-- Name: DepreciationTable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."DepreciationTable_id_seq" OWNED BY public."DepreciationTable".id;


--
-- Name: GoldAndSilver; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."GoldAndSilver" (
    id text NOT NULL,
    "assessmentYear" text NOT NULL,
    "stGoldRate24CPer10Grams" text NOT NULL,
    "stSilverRateFor1Kg" text NOT NULL
);


ALTER TABLE public."GoldAndSilver" OWNER TO postgres;

--
-- Name: Gstr1_11A2A2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gstr1_11A2A2" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    sr_no integer NOT NULL,
    pos text NOT NULL,
    supply text NOT NULL,
    cess text NOT NULL
);


ALTER TABLE public."Gstr1_11A2A2" OWNER TO postgres;

--
-- Name: Gstr1_11A2A2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gstr1_11A2A2_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gstr1_11A2A2_id_seq" OWNER TO postgres;

--
-- Name: Gstr1_11A2A2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gstr1_11A2A2_id_seq" OWNED BY public."Gstr1_11A2A2".id;


--
-- Name: Gstr1_11B1B2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gstr1_11B1B2" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    sr_no integer NOT NULL,
    pos text NOT NULL,
    taxable_value text NOT NULL,
    rate text NOT NULL,
    supply_type text NOT NULL,
    cess text NOT NULL,
    igst text NOT NULL,
    cgst text NOT NULL,
    sgst text NOT NULL
);


ALTER TABLE public."Gstr1_11B1B2" OWNER TO postgres;

--
-- Name: Gstr1_11B1B2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gstr1_11B1B2_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gstr1_11B1B2_id_seq" OWNER TO postgres;

--
-- Name: Gstr1_11B1B2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gstr1_11B1B2_id_seq" OWNED BY public."Gstr1_11B1B2".id;


--
-- Name: Gstr1_4A; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gstr1_4A" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "LegalName" text NOT NULL,
    "GSTN" text NOT NULL,
    pos text NOT NULL,
    "invoice_No" text NOT NULL,
    invoice_date text NOT NULL,
    invoice_value text NOT NULL,
    rate text NOT NULL,
    nature text NOT NULL,
    source text NOT NULL,
    cgst text NOT NULL,
    igst text NOT NULL,
    sgst text NOT NULL,
    supply_type text NOT NULL,
    fy text NOT NULL,
    period text NOT NULL,
    taxpayer_type text NOT NULL,
    "trade_Name" text,
    processed_records text NOT NULL,
    status text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Gstr1_4A" OWNER TO postgres;

--
-- Name: Gstr1_4A_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gstr1_4A_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gstr1_4A_id_seq" OWNER TO postgres;

--
-- Name: Gstr1_4A_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gstr1_4A_id_seq" OWNED BY public."Gstr1_4A".id;


--
-- Name: Gstr1_5A; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gstr1_5A" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    sr_no integer NOT NULL,
    pos text NOT NULL,
    "invoice_No" text NOT NULL,
    supply_type text NOT NULL,
    invoice_value text NOT NULL,
    invoice_date text NOT NULL,
    total_taxable_value text NOT NULL,
    integrated_tax text NOT NULL,
    cess text NOT NULL,
    total_invoice_value text NOT NULL
);


ALTER TABLE public."Gstr1_5A" OWNER TO postgres;

--
-- Name: Gstr1_5A_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gstr1_5A_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gstr1_5A_id_seq" OWNER TO postgres;

--
-- Name: Gstr1_5A_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gstr1_5A_id_seq" OWNED BY public."Gstr1_5A".id;


--
-- Name: Gstr1_5A_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gstr1_5A_item" (
    id integer NOT NULL,
    tax_rate text DEFAULT '0%'::text NOT NULL,
    "Ammmout_of_tax" text NOT NULL,
    "Igst" text NOT NULL,
    cess text NOT NULL,
    "gstr1_5A_id" integer NOT NULL
);


ALTER TABLE public."Gstr1_5A_item" OWNER TO postgres;

--
-- Name: Gstr1_5A_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gstr1_5A_item_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gstr1_5A_item_id_seq" OWNER TO postgres;

--
-- Name: Gstr1_5A_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gstr1_5A_item_id_seq" OWNED BY public."Gstr1_5A_item".id;


--
-- Name: Gstr1_6A; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gstr1_6A" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    sr_no integer NOT NULL,
    pos text NOT NULL,
    invoice_no text NOT NULL,
    supply_type text NOT NULL,
    invoice_data text NOT NULL,
    invoice_value text NOT NULL,
    total_value text NOT NULL,
    gst_payement text NOT NULL,
    total_taxable_value text NOT NULL,
    integarted_tax text NOT NULL,
    cess text NOT NULL
);


ALTER TABLE public."Gstr1_6A" OWNER TO postgres;

--
-- Name: Gstr1_6A_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gstr1_6A_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gstr1_6A_id_seq" OWNER TO postgres;

--
-- Name: Gstr1_6A_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gstr1_6A_id_seq" OWNED BY public."Gstr1_6A".id;


--
-- Name: Gstr1_6A_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gstr1_6A_item" (
    id integer NOT NULL,
    pecentage text NOT NULL,
    integrated_value text NOT NULL,
    cgst text NOT NULL,
    sgst text NOT NULL,
    "gstr1_6A_id" integer NOT NULL
);


ALTER TABLE public."Gstr1_6A_item" OWNER TO postgres;

--
-- Name: Gstr1_6A_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gstr1_6A_item_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gstr1_6A_item_id_seq" OWNER TO postgres;

--
-- Name: Gstr1_6A_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gstr1_6A_item_id_seq" OWNED BY public."Gstr1_6A_item".id;


--
-- Name: Gstr1_7B; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gstr1_7B" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    gstn text NOT NULL,
    sr_no integer NOT NULL,
    pos text NOT NULL,
    taxable_value text NOT NULL,
    supply_type text NOT NULL,
    rate text NOT NULL,
    central_tax text NOT NULL,
    state_tax text NOT NULL,
    cess text NOT NULL,
    place_of_supply text NOT NULL,
    total_taxable text NOT NULL,
    integrated text NOT NULL
);


ALTER TABLE public."Gstr1_7B" OWNER TO postgres;

--
-- Name: Gstr1_7B_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gstr1_7B_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gstr1_7B_id_seq" OWNER TO postgres;

--
-- Name: Gstr1_7B_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gstr1_7B_id_seq" OWNED BY public."Gstr1_7B".id;


--
-- Name: Gstr1_8ABCD; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gstr1_8ABCD" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    gstn text NOT NULL,
    sr_no integer NOT NULL,
    pos text NOT NULL,
    taxable_value text NOT NULL,
    supply_type text NOT NULL,
    rate text NOT NULL,
    central_tax text NOT NULL,
    state_tax text NOT NULL,
    cess text NOT NULL
);


ALTER TABLE public."Gstr1_8ABCD" OWNER TO postgres;

--
-- Name: Gstr1_8ABCD_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gstr1_8ABCD_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gstr1_8ABCD_id_seq" OWNER TO postgres;

--
-- Name: Gstr1_8ABCD_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gstr1_8ABCD_id_seq" OWNED BY public."Gstr1_8ABCD".id;


--
-- Name: Gstr1_9B; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gstr1_9B" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    gstn text NOT NULL,
    sr_no integer NOT NULL,
    recipient_name text NOT NULL,
    name_as_master text NOT NULL,
    debit_credit_note_no text NOT NULL,
    debit_credit_note_date text NOT NULL,
    state_tax text NOT NULL,
    note_type text NOT NULL,
    supply_type text NOT NULL,
    items_details text NOT NULL,
    select_rate text NOT NULL,
    note_values text NOT NULL,
    state_tax_rs text NOT NULL,
    central_tax text NOT NULL,
    cess text NOT NULL
);


ALTER TABLE public."Gstr1_9B" OWNER TO postgres;

--
-- Name: Gstr1_9B_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gstr1_9B_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gstr1_9B_id_seq" OWNER TO postgres;

--
-- Name: Gstr1_9B_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gstr1_9B_id_seq" OWNED BY public."Gstr1_9B".id;


--
-- Name: Gstr1_9B_un; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gstr1_9B_un" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    sr_no integer NOT NULL,
    type text NOT NULL,
    debit_credit_note_no text NOT NULL,
    debit_credit_note_date text NOT NULL,
    state_tax text NOT NULL,
    note_type text NOT NULL,
    supply_type text NOT NULL,
    item_details text NOT NULL,
    select_rate text NOT NULL,
    note_value text NOT NULL,
    state_tax_rs text NOT NULL,
    central_tax_rs text NOT NULL,
    cess text NOT NULL
);


ALTER TABLE public."Gstr1_9B_un" OWNER TO postgres;

--
-- Name: Gstr1_9B_un_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Gstr1_9B_un_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Gstr1_9B_un_id_seq" OWNER TO postgres;

--
-- Name: Gstr1_9B_un_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Gstr1_9B_un_id_seq" OWNED BY public."Gstr1_9B_un".id;


--
-- Name: Insurance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Insurance" (
    id text NOT NULL,
    type text NOT NULL,
    name text NOT NULL,
    mobile text NOT NULL,
    email text NOT NULL,
    address text NOT NULL,
    dob timestamp(3) without time zone NOT NULL,
    "maritalStatus" text NOT NULL,
    gender public."UserGender" NOT NULL,
    "userId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Insurance" OWNER TO postgres;

--
-- Name: InterestAccruedonNational; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."InterestAccruedonNational" (
    id text NOT NULL,
    "purchaseDuration" text NOT NULL
);


ALTER TABLE public."InterestAccruedonNational" OWNER TO postgres;

--
-- Name: InterestAccruedonNationalList; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."InterestAccruedonNationalList" (
    id text NOT NULL,
    "listNumber" text NOT NULL,
    "financeAct" text NOT NULL
);


ALTER TABLE public."InterestAccruedonNationalList" OWNER TO postgres;

--
-- Name: InterestOnKVP; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."InterestOnKVP" (
    id integer NOT NULL,
    year integer NOT NULL,
    rate double precision NOT NULL
);


ALTER TABLE public."InterestOnKVP" OWNER TO postgres;

--
-- Name: InterestOnKVP_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."InterestOnKVP_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."InterestOnKVP_id_seq" OWNER TO postgres;

--
-- Name: InterestOnKVP_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."InterestOnKVP_id_seq" OWNED BY public."InterestOnKVP".id;


--
-- Name: InterestRatesAccrued; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."InterestRatesAccrued" (
    id text NOT NULL,
    duration text NOT NULL,
    rate double precision NOT NULL
);


ALTER TABLE public."InterestRatesAccrued" OWNER TO postgres;

--
-- Name: Invoice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Invoice" (
    id text NOT NULL,
    "invoiceNumber" text,
    type public."InvoiceType" NOT NULL,
    "totalAmount" double precision NOT NULL,
    "totalGst" double precision,
    "stateOfSupply" text NOT NULL,
    cgst double precision,
    sgst double precision,
    igst double precision,
    utgst double precision,
    details text,
    "extraDetails" text,
    "invoiceDate" timestamp(3) without time zone,
    "dueDate" timestamp(3) without time zone,
    "isInventory" boolean,
    "modeOfPayment" public."ModeOfPayment" NOT NULL,
    credit boolean NOT NULL,
    "userId" integer NOT NULL,
    "partyId" text NOT NULL,
    "gstNumber" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status public."InvoiceStatus" NOT NULL
);


ALTER TABLE public."Invoice" OWNER TO postgres;

--
-- Name: InvoiceItem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."InvoiceItem" (
    id text NOT NULL,
    "itemId" text,
    quantity integer NOT NULL,
    discount numeric(65,30) DEFAULT 0.0 NOT NULL,
    "taxPercent" numeric(65,30) DEFAULT 0.0 NOT NULL,
    "invoiceId" text NOT NULL
);


ALTER TABLE public."InvoiceItem" OWNER TO postgres;

--
-- Name: Item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Item" (
    id text NOT NULL,
    "itemName" text NOT NULL,
    unit public."ItemUnit" DEFAULT 'pieces'::public."ItemUnit" NOT NULL,
    price numeric(65,30) NOT NULL,
    "openingStock" numeric(65,30),
    "closingStock" numeric(65,30),
    "purchasePrice" numeric(65,30),
    cgst numeric(65,30),
    sgst numeric(65,30),
    igst numeric(65,30),
    utgst numeric(65,30),
    "taxExempted" boolean DEFAULT false NOT NULL,
    description text,
    "hsnCode" text,
    "categoryId" text,
    "supplierId" text,
    "userId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Item" OWNER TO postgres;

--
-- Name: JournalEntry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."JournalEntry" (
    id text NOT NULL,
    "entryDate" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    description text NOT NULL,
    "userId" integer NOT NULL
);


ALTER TABLE public."JournalEntry" OWNER TO postgres;

--
-- Name: Ledger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Ledger" (
    id text NOT NULL,
    "ledgerName" text NOT NULL,
    "openingBalance" numeric(65,30) DEFAULT 0.0 NOT NULL,
    balance numeric(65,30) DEFAULT 0.0 NOT NULL,
    "userId" integer NOT NULL,
    "partyId" text,
    year integer NOT NULL,
    month integer NOT NULL,
    "ledgerType" public."LedgerType" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Ledger" OWNER TO postgres;

--
-- Name: Library; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Library" (
    id integer NOT NULL,
    pan text NOT NULL,
    section text NOT NULL,
    sub_section text,
    subject text NOT NULL,
    ao_order text NOT NULL,
    itat_no text NOT NULL,
    rsa_no text,
    bench text NOT NULL,
    appeal_no text,
    appellant text,
    respondent text NOT NULL,
    appeal_type text NOT NULL,
    appeal_filed_by text NOT NULL,
    order_result text NOT NULL,
    tribunal_order_date text NOT NULL,
    assessment_year text NOT NULL,
    judgment text NOT NULL,
    conclusion text NOT NULL,
    download text NOT NULL,
    upload text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Library" OWNER TO postgres;

--
-- Name: Library_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Library_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Library_id_seq" OWNER TO postgres;

--
-- Name: Library_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Library_id_seq" OWNED BY public."Library".id;


--
-- Name: Loan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Loan" (
    id text NOT NULL,
    type public."LoanType" NOT NULL,
    name text NOT NULL,
    "shortName" text,
    description text,
    "maxAmount" numeric(65,30),
    "minAmount" numeric(65,30),
    interest numeric(65,30) NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Loan" OWNER TO postgres;

--
-- Name: LoanApplication; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."LoanApplication" (
    id text NOT NULL,
    "loanId" text NOT NULL,
    "loanAmount" numeric(65,30) NOT NULL,
    "loanStatus" public."LoanStatus" DEFAULT 'pending'::public."LoanStatus" NOT NULL,
    "applicantName" text NOT NULL,
    "applicantAge" integer NOT NULL,
    "loanType" public."LoanType" NOT NULL,
    "applicantGender" public."UserGender" NOT NULL,
    nationality public."Nationality" NOT NULL,
    description text NOT NULL,
    salaried boolean NOT NULL,
    "bankAccountId" text NOT NULL,
    phone text,
    email text,
    address text,
    "permanentAddress" text NOT NULL,
    "userId" integer NOT NULL,
    "agentId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."LoanApplication" OWNER TO postgres;

--
-- Name: LoanDocument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."LoanDocument" (
    id text NOT NULL,
    name text NOT NULL,
    "shortName" text NOT NULL,
    mandatory boolean DEFAULT false NOT NULL,
    type public."DocumentType" NOT NULL,
    description text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."LoanDocument" OWNER TO postgres;

--
-- Name: Order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Order" (
    id integer NOT NULL,
    services jsonb NOT NULL,
    status public."OrderStatus" DEFAULT 'pending'::public."OrderStatus" NOT NULL,
    price numeric(65,30) NOT NULL,
    gst numeric(65,30) NOT NULL,
    "orderTotal" numeric(65,30) NOT NULL,
    "stateOfSupply" text NOT NULL,
    "userId" integer NOT NULL
);


ALTER TABLE public."Order" OWNER TO postgres;

--
-- Name: Order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Order_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Order_id_seq" OWNER TO postgres;

--
-- Name: Order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Order_id_seq" OWNED BY public."Order".id;


--
-- Name: Otp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Otp" (
    id integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    otp text NOT NULL,
    "userId" integer NOT NULL,
    used boolean DEFAULT false NOT NULL,
    deletedate timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Otp" OWNER TO postgres;

--
-- Name: Otp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Otp_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Otp_id_seq" OWNER TO postgres;

--
-- Name: Otp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Otp_id_seq" OWNED BY public."Otp".id;


--
-- Name: PanAndITCodeByStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PanAndITCodeByStatus" (
    id text NOT NULL,
    status text NOT NULL,
    "incomeTaxCode" integer NOT NULL,
    "panCode" text NOT NULL
);


ALTER TABLE public."PanAndITCodeByStatus" OWNER TO postgres;

--
-- Name: PanAndITCodeByStatusList; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PanAndITCodeByStatusList" (
    id text NOT NULL,
    "financialYear" text NOT NULL
);


ALTER TABLE public."PanAndITCodeByStatusList" OWNER TO postgres;

--
-- Name: Party; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Party" (
    id text NOT NULL,
    "partyName" text NOT NULL,
    type public."PartyType" NOT NULL,
    gstin text,
    pan text,
    tan text,
    upi text,
    email text,
    phone text,
    address text,
    "bankName" text,
    "bankAccountNumber" text,
    "bankIfsc" text,
    "bankBranch" text,
    "userId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Party" OWNER TO postgres;

--
-- Name: Payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Payment" (
    id text NOT NULL,
    razorpay_order_id text NOT NULL,
    razorpay_payment_id text NOT NULL,
    status public."PaymentStatus" DEFAULT 'created'::public."PaymentStatus" NOT NULL,
    "userId" integer NOT NULL,
    "orderId" integer NOT NULL
);


ALTER TABLE public."Payment" OWNER TO postgres;

--
-- Name: Post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Post" (
    id text NOT NULL,
    "userId" integer NOT NULL,
    title text NOT NULL,
    "contentHeading" text NOT NULL,
    "contentDescription" text NOT NULL,
    category text NOT NULL,
    "imageUrl" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Post" OWNER TO postgres;

--
-- Name: RegisterServices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RegisterServices" (
    id integer NOT NULL,
    "serviceId" integer NOT NULL,
    "userId" integer NOT NULL,
    "aadhaarCard" text NOT NULL,
    "panCard" text NOT NULL,
    "gstCertificate" text NOT NULL,
    photo text NOT NULL
);


ALTER TABLE public."RegisterServices" OWNER TO postgres;

--
-- Name: RegisterServices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."RegisterServices_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."RegisterServices_id_seq" OWNER TO postgres;

--
-- Name: RegisterServices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."RegisterServices_id_seq" OWNED BY public."RegisterServices".id;


--
-- Name: RegisterStartup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."RegisterStartup" (
    id integer NOT NULL,
    title text NOT NULL,
    image text NOT NULL,
    "priceWithGst" integer,
    "aboutService" text,
    "userId" integer NOT NULL,
    categories public."StartupCategory" NOT NULL
);


ALTER TABLE public."RegisterStartup" OWNER TO postgres;

--
-- Name: RegisterStartup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."RegisterStartup_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."RegisterStartup_id_seq" OWNER TO postgres;

--
-- Name: RegisterStartup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."RegisterStartup_id_seq" OWNED BY public."RegisterStartup".id;


--
-- Name: Service; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Service" (
    id text NOT NULL,
    "serviceName" text NOT NULL,
    "serviceType" text,
    "imgUrl" text,
    description text,
    price numeric(65,30) NOT NULL,
    gst numeric(65,30) NOT NULL,
    documents jsonb NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Service" OWNER TO postgres;

--
-- Name: StatusWiseIncomeTaxCode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."StatusWiseIncomeTaxCode" (
    id integer NOT NULL,
    code text NOT NULL,
    status text NOT NULL
);


ALTER TABLE public."StatusWiseIncomeTaxCode" OWNER TO postgres;

--
-- Name: StatusWiseIncomeTaxCode_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."StatusWiseIncomeTaxCode_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."StatusWiseIncomeTaxCode_id_seq" OWNER TO postgres;

--
-- Name: StatusWiseIncomeTaxCode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."StatusWiseIncomeTaxCode_id_seq" OWNED BY public."StatusWiseIncomeTaxCode".id;


--
-- Name: Subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Subscriptions" (
    id text NOT NULL,
    "userId" integer NOT NULL,
    "amountForServices" double precision NOT NULL,
    txnid text,
    pid text,
    "subscriptionDuration" public."SubscriptionsDuration" DEFAULT 'monthly'::public."SubscriptionsDuration" NOT NULL,
    status public."SubscriptionStatus" DEFAULT 'pending'::public."SubscriptionStatus" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Subscriptions" OWNER TO postgres;

--
-- Name: Transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Transaction" (
    id text NOT NULL,
    "ledgerId" text NOT NULL,
    "journalEntryId" text NOT NULL,
    amount numeric(65,30) NOT NULL,
    "transactionType" public."TransactionType" NOT NULL,
    "userId" integer NOT NULL,
    date timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Transaction" OWNER TO postgres;

--
-- Name: UploadedDocument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UploadedDocument" (
    id text NOT NULL,
    "userId" integer NOT NULL,
    "fileName" text NOT NULL,
    "applicationId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."UploadedDocument" OWNER TO postgres;

--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    "firstName" text NOT NULL,
    "middleName" text,
    "lastName" text,
    "fatherName" text,
    phone text,
    gender public."UserGender" NOT NULL,
    address text,
    pin text,
    aadhaar text,
    pan text,
    dob timestamp(3) without time zone,
    avatar text,
    "adminId" integer,
    "superadminId" integer,
    verified boolean DEFAULT false NOT NULL,
    "userType" public."UserType" DEFAULT 'normal'::public."UserType" NOT NULL,
    ispanlinked boolean DEFAULT false NOT NULL,
    inventory boolean DEFAULT false NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: UserProfile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."UserProfile" (
    id integer NOT NULL,
    pan text,
    aadhaar text,
    "firstName" text NOT NULL,
    "middleName" text,
    "lastName" text,
    email text NOT NULL,
    phone text,
    gender public."UserGender" NOT NULL,
    address text,
    pincode text,
    "userId" integer NOT NULL
);


ALTER TABLE public."UserProfile" OWNER TO postgres;

--
-- Name: UserProfile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."UserProfile_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."UserProfile_id_seq" OWNER TO postgres;

--
-- Name: UserProfile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."UserProfile_id_seq" OWNED BY public."UserProfile".id;


--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_id_seq" OWNER TO postgres;

--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- Name: Visitor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Visitor" (
    id integer NOT NULL,
    count integer DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Visitor" OWNER TO postgres;

--
-- Name: Visitor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Visitor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Visitor_id_seq" OWNER TO postgres;

--
-- Name: Visitor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Visitor_id_seq" OWNED BY public."Visitor".id;


--
-- Name: _AccountToInvoice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_AccountToInvoice" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_AccountToInvoice" OWNER TO postgres;

--
-- Name: _ApiServiceToSubscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_ApiServiceToSubscriptions" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_ApiServiceToSubscriptions" OWNER TO postgres;

--
-- Name: _CartServices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_CartServices" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_CartServices" OWNER TO postgres;

--
-- Name: _CartToRegisterServices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_CartToRegisterServices" (
    "A" text NOT NULL,
    "B" integer NOT NULL
);


ALTER TABLE public."_CartToRegisterServices" OWNER TO postgres;

--
-- Name: _CartToRegisterStartup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_CartToRegisterStartup" (
    "A" text NOT NULL,
    "B" integer NOT NULL
);


ALTER TABLE public."_CartToRegisterStartup" OWNER TO postgres;

--
-- Name: _CostInflationIndexToCostInflationList; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_CostInflationIndexToCostInflationList" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_CostInflationIndexToCostInflationList" OWNER TO postgres;

--
-- Name: _CountryCodeToCountryCodeList; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_CountryCodeToCountryCodeList" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_CountryCodeToCountryCodeList" OWNER TO postgres;

--
-- Name: _InterestAccruedonNationalToInterestAccruedonNationalList; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_InterestAccruedonNationalToInterestAccruedonNationalList" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_InterestAccruedonNationalToInterestAccruedonNationalList" OWNER TO postgres;

--
-- Name: _InterestAccruedonNationalToInterestRatesAccrued; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_InterestAccruedonNationalToInterestRatesAccrued" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_InterestAccruedonNationalToInterestRatesAccrued" OWNER TO postgres;

--
-- Name: _LoanDocumentToUploadedDocument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_LoanDocumentToUploadedDocument" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_LoanDocumentToUploadedDocument" OWNER TO postgres;

--
-- Name: _LoanToLoanDocument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_LoanToLoanDocument" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_LoanToLoanDocument" OWNER TO postgres;

--
-- Name: _PanAndITCodeByStatusToPanAndITCodeByStatusList; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_PanAndITCodeByStatusToPanAndITCodeByStatusList" (
    "A" text NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_PanAndITCodeByStatusToPanAndITCodeByStatusList" OWNER TO postgres;

--
-- Name: _RegisterServicesToSubscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_RegisterServicesToSubscriptions" (
    "A" integer NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_RegisterServicesToSubscriptions" OWNER TO postgres;

--
-- Name: _RegisterStartupToSubscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."_RegisterStartupToSubscriptions" (
    "A" integer NOT NULL,
    "B" text NOT NULL
);


ALTER TABLE public."_RegisterStartupToSubscriptions" OWNER TO postgres;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: gstr1_12HSN; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."gstr1_12HSN" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    sr_no integer NOT NULL,
    pos text NOT NULL,
    taxable_value text NOT NULL,
    rate text NOT NULL,
    supply_type text NOT NULL,
    cess text NOT NULL,
    igst text NOT NULL,
    cgst text NOT NULL,
    sgst text NOT NULL
);


ALTER TABLE public."gstr1_12HSN" OWNER TO postgres;

--
-- Name: gstr1_12HSN_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."gstr1_12HSN_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."gstr1_12HSN_id_seq" OWNER TO postgres;

--
-- Name: gstr1_12HSN_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."gstr1_12HSN_id_seq" OWNED BY public."gstr1_12HSN".id;


--
-- Name: Billpayable id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Billpayable" ALTER COLUMN id SET DEFAULT nextval('public."Billpayable_id_seq"'::regclass);


--
-- Name: Billrecieve id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Billrecieve" ALTER COLUMN id SET DEFAULT nextval('public."Billrecieve_id_seq"'::regclass);


--
-- Name: BusinessProfile id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BusinessProfile" ALTER COLUMN id SET DEFAULT nextval('public."BusinessProfile_id_seq"'::regclass);


--
-- Name: Career id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Career" ALTER COLUMN id SET DEFAULT nextval('public."Career_id_seq"'::regclass);


--
-- Name: ContactUs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ContactUs" ALTER COLUMN id SET DEFAULT nextval('public."ContactUs_id_seq"'::regclass);


--
-- Name: DepreciationTable id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DepreciationTable" ALTER COLUMN id SET DEFAULT nextval('public."DepreciationTable_id_seq"'::regclass);


--
-- Name: Gstr1_11A2A2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_11A2A2" ALTER COLUMN id SET DEFAULT nextval('public."Gstr1_11A2A2_id_seq"'::regclass);


--
-- Name: Gstr1_11B1B2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_11B1B2" ALTER COLUMN id SET DEFAULT nextval('public."Gstr1_11B1B2_id_seq"'::regclass);


--
-- Name: Gstr1_4A id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_4A" ALTER COLUMN id SET DEFAULT nextval('public."Gstr1_4A_id_seq"'::regclass);


--
-- Name: Gstr1_5A id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_5A" ALTER COLUMN id SET DEFAULT nextval('public."Gstr1_5A_id_seq"'::regclass);


--
-- Name: Gstr1_5A_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_5A_item" ALTER COLUMN id SET DEFAULT nextval('public."Gstr1_5A_item_id_seq"'::regclass);


--
-- Name: Gstr1_6A id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_6A" ALTER COLUMN id SET DEFAULT nextval('public."Gstr1_6A_id_seq"'::regclass);


--
-- Name: Gstr1_6A_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_6A_item" ALTER COLUMN id SET DEFAULT nextval('public."Gstr1_6A_item_id_seq"'::regclass);


--
-- Name: Gstr1_7B id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_7B" ALTER COLUMN id SET DEFAULT nextval('public."Gstr1_7B_id_seq"'::regclass);


--
-- Name: Gstr1_8ABCD id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_8ABCD" ALTER COLUMN id SET DEFAULT nextval('public."Gstr1_8ABCD_id_seq"'::regclass);


--
-- Name: Gstr1_9B id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_9B" ALTER COLUMN id SET DEFAULT nextval('public."Gstr1_9B_id_seq"'::regclass);


--
-- Name: Gstr1_9B_un id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_9B_un" ALTER COLUMN id SET DEFAULT nextval('public."Gstr1_9B_un_id_seq"'::regclass);


--
-- Name: InterestOnKVP id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InterestOnKVP" ALTER COLUMN id SET DEFAULT nextval('public."InterestOnKVP_id_seq"'::regclass);


--
-- Name: Library id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Library" ALTER COLUMN id SET DEFAULT nextval('public."Library_id_seq"'::regclass);


--
-- Name: Order id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order" ALTER COLUMN id SET DEFAULT nextval('public."Order_id_seq"'::regclass);


--
-- Name: Otp id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Otp" ALTER COLUMN id SET DEFAULT nextval('public."Otp_id_seq"'::regclass);


--
-- Name: RegisterServices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RegisterServices" ALTER COLUMN id SET DEFAULT nextval('public."RegisterServices_id_seq"'::regclass);


--
-- Name: RegisterStartup id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RegisterStartup" ALTER COLUMN id SET DEFAULT nextval('public."RegisterStartup_id_seq"'::regclass);


--
-- Name: StatusWiseIncomeTaxCode id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."StatusWiseIncomeTaxCode" ALTER COLUMN id SET DEFAULT nextval('public."StatusWiseIncomeTaxCode_id_seq"'::regclass);


--
-- Name: User id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- Name: UserProfile id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserProfile" ALTER COLUMN id SET DEFAULT nextval('public."UserProfile_id_seq"'::regclass);


--
-- Name: Visitor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Visitor" ALTER COLUMN id SET DEFAULT nextval('public."Visitor_id_seq"'::regclass);


--
-- Name: gstr1_12HSN id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."gstr1_12HSN" ALTER COLUMN id SET DEFAULT nextval('public."gstr1_12HSN_id_seq"'::regclass);


--
-- Data for Name: About; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."About" (id, name, "position", image, description) FROM stdin;
\.


--
-- Data for Name: Account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Account" (id, "accountName", "totalDebit", "totalCredit", "debitBalance", "creditBalance", date, "userId") FROM stdin;
\.


--
-- Data for Name: Agent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Agent" (id, "userId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: ApiService; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ApiService" (id, title, overview, price, upcoming, endpoint, "bodyParams", response, "responseJSON", "createdAt", "updatedAt", category) FROM stdin;
signup	Signup	API enables users to register for a service by sending a request with their information and receiving a response with status and authentication credentials	500	f	{"method": "post", "endpoint": "undefined/user/sign-up"}	[{"name": "first_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "last_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "phone", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "email", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "password", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "pincode", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	[{"name": "id", "type": "Number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "email", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "first_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "last_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "phone", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "pincode", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	"{\\n    \\"status\\": true,\\n    \\"results\\": {\\n        \\"status\\": 200,\\n        \\"message\\": \\"Registration Successfull\\",\\n        \\"data\\": {\\n            \\"id\\": 134,\\n            \\"email\\": \\"Vineetka@gmail.com\\",\\n            \\"first_name\\": \\"Vineet\\",\\n            \\"last_name\\": \\"Sharma\\",\\n            \\"phone\\": \\"9146732156\\",\\n            \\"pincode\\": \\"2411122\\"\\n        },\\n    }\\n}"	2025-04-22 20:37:26.093	2025-04-22 20:37:26.093	Authentication
admin_signup	Admin SignUp	API allows administrators to log in to a system by sending a request with their credentials and receiving a response with authentication status and a session token.	500	f	{"method": "post", "endpoint": "undefined/admin/sign-up"}	[{"name": "first_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "last_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "phone", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "email", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "password", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "pincode", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	[{"name": "id", "type": "Number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "email", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "first_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "last_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "phone", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "pincode", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "isAdmin", "type": "boolean", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	"{\\n    \\"status\\": true,\\n    \\"results\\": {\\n        \\"status\\": 200,\\n        \\"message\\": \\"Registration Successfull\\",\\n        \\"data\\": {\\n            \\"id\\": 134,\\n            \\"email\\": \\"Vineetka@gmail.com\\",\\n            \\"first_name\\": \\"Vineet\\",\\n            \\"last_name\\": \\"Sharma\\",\\n            \\"phone\\": \\"9146732156\\",\\n            \\"pincode\\": \\"2411122\\",\\n            \\"isAdmin\\": true\\n        },\\n    }\\n}"	2025-04-23 06:13:24.693	2025-04-23 06:13:24.693	Authentication
form16	Form-16	The API uses OCR technology to convert the image data into machine-readable text and retrieve the required information, such as the employees name, PAN number, and salary details.	500	f	{"method": "post", "endpoint": "undefined/form-16"}	[{"name": "bsr_code", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "challan_date", "type": "Number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "challan_serial_no", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "provisional_receipt_number", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "challan_amount", "type": "Number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "unique_pan_amount_combination_for_challan", "type": "Array", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	[{"name": "bsr_code", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "challan_date", "type": "Number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "challlan_serial_no", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "job_id", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "tan", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "financial_year", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "quarter", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "status", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	"{\\n    \\"bsr_code\\": \\"1234567\\",\\n    \\"challan_date\\": 1670783400000,\\n    \\"challlan_serial_no\\": \\"01234\\",\\n    \\"job: {\\n        job_id: \\"12345\\",\\n        tan: \\"AAAA12345A\\",\\n        financial_year: \\"2020-21\\",\\n        quarter: \\"q1\\",\\n        status: \\"ok\\"\\n    }\\n}"	2025-04-23 06:38:14.668	2025-04-23 06:38:14.668	Extraction_E-KYC
pan	Pan	API allows user to send picture for PAN Card and sends the information of the pan card in json format.	500	f	{"method": "post", "endpoint": "https://ocr.itaxeasy.com/pan"}	[{"name": "file", "type": "Form-data", "required": "Yes", "description": "The File which user wants to extract information from i.e. PAN Card Picture."}]	[{"name": "name", "type": "String", "required": "Yes", "description": "The extracted name from the file"}, {"name": "fatherName", "type": "String", "required": "Yes", "description": "The extracted father's name from the file"}, {"name": "dob", "type": "String", "required": "Yes", "description": "The extracted dob from the file"}, {"name": "pan", "type": "String", "required": "Yes", "description": "The extracted PAN from the file"}]	"{\\n      \\"status\\": \\"success\\",\\n      \\"data\\": {\\n          \\"name\\": \\"\\",\\n          \\"fatherName\\": \\"\\",\\n          \\"dob\\": \\"\\",\\n          \\"pan\\": \\"\\"\\n      }\\n  }"	2025-04-23 06:44:46.756	2025-04-23 06:44:46.756	Extraction_E-KYC
pin_code_by_city	PIN Code by City	Pin code API provides a solution for retrieving postal codes (known as PIN codes) based on a given city name.	500	f	{"method": "post", "endpoint": "undefined/pincode/pincodebycity"}	\N	[{"name": "officeName", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "pincode", "type": "Number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "taluk", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "districtName", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "stateName", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	"{\\n    \\"success\\": true,\\n    \\"info\\": [\\n        {\\n            \\"officeName\\": \\"Defence Colony S.O (Meerut)\\",\\n            \\"pincode\\": 250001,\\n            \\"taluk\\": \\"Meerut\\",\\n            \\"districtName\\": \\"Meerut\\",\\n            \\"stateName\\": \\"UTTAR PRADESH\\"\\n        },\\n        {\\n            \\"officeName\\": \\"Saket S.O (Meerut)\\",\\n            \\"pincode\\": 250003,\\n            \\"taluk\\": \\"Meerut\\",\\n            \\"districtName\\": \\"Meerut\\",\\n            \\"stateName\\": \\"UTTAR PRADESH\\"\\n        },\\n    ]\\n  }"	2025-04-23 06:50:52.776	2025-04-23 06:50:52.776	Post_Office
ifsc_details	IFSC Details	The IFSC (Indian Financial System Code) Details API is used to retrieve information about a particular bank branch in India, including the banks name, address, contact details, and IFSC code, using the IFSC code as the key identifier.	500	f	{"method": "post", "endpoint": "https://laravel.itaxeasy.com/api/  get-details?ifsc"}	\N	[{"name": "MICR", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "BRANCH", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "ADDRESS", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "STATE", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "CONTACT", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "UPI", "type": "Boolean", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "RTGS", "type": "Boolean", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "CITY", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "CENTRE", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "DISTRICT", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "NEFT", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "IMPS", "type": "Boolean", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "SWIFT", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "ISO3166", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "BANK", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "BANKCODE", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "IFSC", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	"{\\n        \\"data\\": {\\n        \\"MICR\\": null,\\n        \\"BRANCH\\": \\"Noida Branch\\",\\n        \\"ADDRESS\\": \\"B-121, Sector-5,Noida-201301\\",\\n        \\"STATE\\": \\"UTTAR PRADESH\\",\\n        \\"CONTACT\\": \\"+911133996699\\",\\n        \\"UPI\\": true,\\n        \\"RTGS\\": true,\\n        \\"CITY\\": \\"NOIDA\\",\\n        \\"CENTRE\\": \\"Gautam Buddh Nagar\\",\\n        \\"DISTRICT\\": \\"Gautam Buddh Nagar\\",\\n        \\"NEFT\\": true,\\n        \\"IMPS\\": true,\\n        \\"SWIFT\\": null,\\n        \\"ISO3166\\": \\"IN-UP\\",\\n        \\"BANK\\": \\"Paytm Payments Bank\\",\\n        \\"BANKCODE\\": \\"PYTM\\",\\n        \\"IFSC\\": \\"PYTM0123456\\"\\n    }\\n        }"	2025-04-23 07:02:37.69	2025-04-23 07:02:37.69	Bank
logout	Logout	API allows users to log out of a system by sending a request to invalidate their current session and terminate authentication.	500	f	{"method": "post", "endpoint": "undefined/"}	\N	[{"name": "x-apideck-consumer-id", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	"curl --request POST\\n--url https://api.sandbox.co.in/\\n--header 'Accept: application/json'\\n--header 'Content-Type: application/json'\\n--header 'x-api-version: 1.0'  --data"	2025-04-23 10:13:50.624	2025-04-23 10:13:50.624	Authentication
form-16	Form-16	The API uses OCR technology to convert the image data into machine-readable text and retrieve the required information, such as the employees name, PAN number, and salary details.	500	f	{"method": "post", "endpoint": "undefined/form-16"}	[{"name": "bsr_code", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "challan_date", "type": "Number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "challan_serial_no", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "provisional_receipt_number", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "challan_amount", "type": "Number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "unique_pan_amount_combination_for_challan", "type": "Array", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	[{"name": "bsr_code", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "challan_date", "type": "Number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "challlan_serial_no", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "job_id", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "tan", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "financial_year", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "quarter", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "status", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	"{\\n    \\"bsr_code\\": \\"1234567\\",\\n    \\"challan_date\\": 1670783400000,\\n    \\"challlan_serial_no\\": \\"01234\\",\\n    \\"job: {\\n        job_id: \\"12345\\",\\n        tan: \\"AAAA12345A\\",\\n        financial_year: \\"2020-21\\",\\n        quarter: \\"q1\\",\\n        status: \\"ok\\"\\n    }\\n}"	2025-04-23 11:05:55.962	2025-04-23 11:05:55.962	Extraction_E-KYC
login	Login	API allows users to log in to a system by sending a request with their credentials and receiving a response with authentication status and a session token	500	f	{"method": "post", "endpoint": "undefined/users/login"}	[{"name": "email", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "password", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	[{"name": "id", "type": "number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "email", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "first_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "last_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "userType", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "phone", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "pincode", "type": "number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "isverified", "type": "Boolean", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	"{\\n    \\"status\\": true,\\n    \\"results\\": {\\n        \\"status\\": 200,\\n        \\"message\\": \\"login successfull\\",\\n        \\"data\\": {\\n            \\"id\\": 54,\\n            \\"email\\": \\"vxxxxxxxxxxu@gmail.com\\",\\n            \\"first_name\\": \\"Vineet\\",\\n            \\"last_name\\": \\"Sharma\\",\\n            \\"userType\\": \\"normal\\",\\n            \\"phone\\": \\"8xxxxxxxx5\\",\\n            \\"pincode\\": \\"241122\\",\\n            \\"isverified\\": true\\n        },\\n}"	2025-04-23 14:38:47.267	2025-04-23 14:38:47.267	Authentication
adminsignup	Admin SignUp	API allows administrators to log in to a system by sending a request with their credentials and receiving a response with authentication status and a session token.	500	f	{"method": "post", "endpoint": "undefined/admin/sign-up"}	[{"name": "first_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "last_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "phone", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "email", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "password", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "pincode", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	[{"name": "id", "type": "Number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "email", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "first_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "last_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "phone", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "pincode", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "isAdmin", "type": "boolean", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	"{\\n    \\"status\\": true,\\n    \\"results\\": {\\n        \\"status\\": 200,\\n        \\"message\\": \\"Registration Successfull\\",\\n        \\"data\\": {\\n            \\"id\\": 134,\\n            \\"email\\": \\"Vineetka@gmail.com\\",\\n            \\"first_name\\": \\"Vineet\\",\\n            \\"last_name\\": \\"Sharma\\",\\n            \\"phone\\": \\"9146732156\\",\\n            \\"pincode\\": \\"2411122\\",\\n            \\"isAdmin\\": true\\n        },\\n    }\\n}"	2025-04-25 11:37:19.828	2025-04-25 11:37:19.828	Authentication
adminlogin	Admin Login	API allows administrators to create a new account by sending a request with their information and receiving a response with status and authentication credentials.	500	f	{"method": "post", "endpoint": "undefined/admin/login"}	[{"name": "email", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "password", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	[{"name": "id", "type": "number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "email", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "first_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "last_name", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "userType", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "phone", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "pincode", "type": "number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "isverified", "type": "Boolean", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "isAdmin", "type": "Boolean", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	"{\\n    \\"status\\": true,\\n    \\"results\\": {\\n        \\"status\\": 200,\\n        \\"message\\": \\"login successfull\\",\\n        \\"data\\": {\\n            \\"id\\": 54,\\n            \\"email\\": \\"vxxxxxxxxxxu@gmail.com\\",\\n            \\"first_name\\": \\"Vineet\\",\\n            \\"last_name\\": \\"Sharma\\",\\n            \\"userType\\": \\"normal\\",\\n            \\"phone\\": \\"8xxxxxxxx5\\",\\n            \\"pincode\\": \\"241122\\",\\n            \\"isverified\\": true,\\n            \\"isAdmin\\": true\\n        },\\n}"	2025-04-26 12:02:54.379	2025-04-26 12:02:54.379	Authentication
pincodebycity	PIN Code by City	Pin code API provides a solution for retrieving postal codes (known as PIN codes) based on a given city name.	500	f	{"method": "post", "endpoint": "undefined/pincode/pincodebycity"}	\N	[{"name": "officeName", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "pincode", "type": "Number", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "taluk", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "districtName", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "stateName", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	"{\\n    \\"success\\": true,\\n    \\"info\\": [\\n        {\\n            \\"officeName\\": \\"Defence Colony S.O (Meerut)\\",\\n            \\"pincode\\": 250001,\\n            \\"taluk\\": \\"Meerut\\",\\n            \\"districtName\\": \\"Meerut\\",\\n            \\"stateName\\": \\"UTTAR PRADESH\\"\\n        },\\n        {\\n            \\"officeName\\": \\"Saket S.O (Meerut)\\",\\n            \\"pincode\\": 250003,\\n            \\"taluk\\": \\"Meerut\\",\\n            \\"districtName\\": \\"Meerut\\",\\n            \\"stateName\\": \\"UTTAR PRADESH\\"\\n        },\\n    ]\\n  }"	2025-04-26 12:02:59.191	2025-04-26 12:02:59.191	Post_Office
verifyaccounts	Verify Accounts	API provides a simple way to verify the authenticity of a users account information, typically by sending a confirmation code to their email or phone number.	500	f	{"method": "post", "endpoint": "undefined/email/verify"}	\N	[{"name": "status", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}, {"name": "message", "type": "String", "required": "Yes", "description": "The id of the customer stored inside Apideck Vault. This can be a user id, account id, device id or whatever entity that can have integration within your app"}]	"{\\n    \\"status\\": \\"success\\",\\n    \\"message\\": \\"user verified successfully\\"\\n}"	2025-04-29 16:29:48.503	2025-04-29 16:29:48.503	Bank
\.


--
-- Data for Name: BankDetails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."BankDetails" (id, "accountHolderName", "bankName", "bankAccountNo", "bankIfsc", "bankBranch", "bankAccountType", "userId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Billpayable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Billpayable" (id, "supplierName", "supplierAddress", contact, "billDate", "dueDate", "billAmount", "billNumber", "billDiscription", "paymentMethod", "transactionId", "paymentDate", "paymentAmount", tax, comment, "invoiceNumber") FROM stdin;
\.


--
-- Data for Name: Billrecieve; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Billrecieve" (id, "billNumber", amount, tax, "customerName", "customerAddress", contact, "itemQuantity", "itemPrice", "itemDescription", "paymentStatus", "paymentMethod", "dueDate", comment) FROM stdin;
\.


--
-- Data for Name: BusinessProfile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."BusinessProfile" (id, "businessName", pan, tan, taxpayer_type, msme_number, status, ctb, gstin, statecode, street, city, dst, stcd, landmark, "bankName", "bankAccountNo", "bankIfsc", "bankBranch", "userId", "createdAt", "updatedAt", "isAddressVerified", "isBusinessNameVerified", "isGstinVerified", "isPanVerified", "isStateVerified", pincode, state) FROM stdin;
3	hgg 	BNJPS3408M	\N	hh	\N	ybhvhv	hhh	23BNJPS3408M1ZP	23	hhh	hhh	dw	hhh	wd	\N	\N	\N	\N	8	2025-05-12 21:08:04.06	2025-05-12 21:08:04.06	\N	\N	\N	\N	\N	\N	\N
4	hgg 	BNJPS3408M	\N	hh	\N	ybhvhv	hhh	23BNJPS3408M1ZP	23	hhh	Ghaziabad	hgg	hhh	hhhg	\N	\N	\N	\N	2	2025-05-14 07:57:55.597	2025-05-14 07:57:55.597	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: Career; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Career" (id, name, address, pin, email, mobile, skills, gender, cv, "createdAt", "updatedAt") FROM stdin;
4	Prince	da	213445	akshat.2226cseai1041@kiet.edu	9636286581	Available in CV	female	https://res.cloudinary.com/drl3vjskb/raw/upload/v1747119813/dashboard/careers/akshat.2226cseai1041%40kiet.edu/GoldS_1747119809509.pdf	2025-05-13 07:03:32.495	2025-05-13 07:03:32.495
5	AKSHAT	da	213445	akshatg9636@gmail.com	9636286581	Available in CV	male	https://res.cloudinary.com/drl3vjskb/raw/upload/v1747120468/dashboard/careers/akshatg9636%40gmail.com/Whats_1747120463558.jpg	2025-05-13 07:14:26.839	2025-05-13 07:14:26.839
7	Prince	efsefsrs	213442	ak@gmail.com	9636286581	Available in CV	female	https://res.cloudinary.com/drl3vjskb/raw/upload/v1747122690/dashboard/careers/ak%40gmail.com/Aksha_1747122685186.pdf	2025-05-13 07:51:28.436	2025-05-13 07:51:28.436
8	Akshat	hhhh	213445	agk@gmail.com	+91 1234567890	Available in CV	male	https://res.cloudinary.com/drl3vjskb/raw/upload/v1750155632/dashboard/careers/agk%40gmail.com/photo_1750155627500.pdf	2025-06-17 10:20:32.985	2025-06-17 10:20:32.985
\.


--
-- Data for Name: Cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Cart" (id, "userId", "createdAt", "updatedAt", category) FROM stdin;
42241746-495d-448e-8206-00e3c733327f	1	2025-04-22 20:33:01.112	2025-05-02 17:42:15.348	STARTUP_REGISTRATION
a8faa7ae-6ade-4811-a07e-ccacb0ed10cb	2	2025-04-26 08:02:43.872	2025-05-23 20:14:01.773	STARTUP_REGISTRATION
\.


--
-- Data for Name: Category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Category" (id, "categoryName", "userId") FROM stdin;
\.


--
-- Data for Name: Client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Client" (id, "userId", "agentId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: ContactUs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."ContactUs" (id, name, email, message) FROM stdin;
1	AKSHAT	akshatg9636@gmail.com	d
2	da	akshat.2226cseai1041@kiet.edu	ca
3	Akshat	mukulbedi@yahoo.com	adwd
4	AKSHAT	satyarshishukla123@gmail.com	dwad
\.


--
-- Data for Name: CostInflationIndex; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CostInflationIndex" (id, "financialYear", "costInflationIndex") FROM stdin;
\.


--
-- Data for Name: CostInflationList; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CostInflationList" (id, "financeAct", "listName") FROM stdin;
\.


--
-- Data for Name: CountryCode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CountryCode" (id, "countryCode", "countryName") FROM stdin;
\.


--
-- Data for Name: CountryCodeList; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CountryCodeList" (id, "assessYear", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: DepreciationTable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."DepreciationTable" (id, "assetType", "depreciationRate") FROM stdin;
\.


--
-- Data for Name: GoldAndSilver; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."GoldAndSilver" (id, "assessmentYear", "stGoldRate24CPer10Grams", "stSilverRateFor1Kg") FROM stdin;
\.


--
-- Data for Name: Gstr1_11A2A2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gstr1_11A2A2" (id, "userId", sr_no, pos, supply, cess) FROM stdin;
\.


--
-- Data for Name: Gstr1_11B1B2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gstr1_11B1B2" (id, "userId", sr_no, pos, taxable_value, rate, supply_type, cess, igst, cgst, sgst) FROM stdin;
\.


--
-- Data for Name: Gstr1_4A; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gstr1_4A" (id, "userId", "LegalName", "GSTN", pos, "invoice_No", invoice_date, invoice_value, rate, nature, source, cgst, igst, sgst, supply_type, fy, period, taxpayer_type, "trade_Name", processed_records, status, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Gstr1_5A; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gstr1_5A" (id, "userId", sr_no, pos, "invoice_No", supply_type, invoice_value, invoice_date, total_taxable_value, integrated_tax, cess, total_invoice_value) FROM stdin;
\.


--
-- Data for Name: Gstr1_5A_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gstr1_5A_item" (id, tax_rate, "Ammmout_of_tax", "Igst", cess, "gstr1_5A_id") FROM stdin;
\.


--
-- Data for Name: Gstr1_6A; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gstr1_6A" (id, "userId", sr_no, pos, invoice_no, supply_type, invoice_data, invoice_value, total_value, gst_payement, total_taxable_value, integarted_tax, cess) FROM stdin;
\.


--
-- Data for Name: Gstr1_6A_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gstr1_6A_item" (id, pecentage, integrated_value, cgst, sgst, "gstr1_6A_id") FROM stdin;
\.


--
-- Data for Name: Gstr1_7B; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gstr1_7B" (id, "userId", gstn, sr_no, pos, taxable_value, supply_type, rate, central_tax, state_tax, cess, place_of_supply, total_taxable, integrated) FROM stdin;
\.


--
-- Data for Name: Gstr1_8ABCD; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gstr1_8ABCD" (id, "userId", gstn, sr_no, pos, taxable_value, supply_type, rate, central_tax, state_tax, cess) FROM stdin;
\.


--
-- Data for Name: Gstr1_9B; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gstr1_9B" (id, "userId", gstn, sr_no, recipient_name, name_as_master, debit_credit_note_no, debit_credit_note_date, state_tax, note_type, supply_type, items_details, select_rate, note_values, state_tax_rs, central_tax, cess) FROM stdin;
\.


--
-- Data for Name: Gstr1_9B_un; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gstr1_9B_un" (id, "userId", sr_no, type, debit_credit_note_no, debit_credit_note_date, state_tax, note_type, supply_type, item_details, select_rate, note_value, state_tax_rs, central_tax_rs, cess) FROM stdin;
\.


--
-- Data for Name: Insurance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Insurance" (id, type, name, mobile, email, address, dob, "maritalStatus", gender, "userId", "createdAt", "updatedAt") FROM stdin;
2dfb257b-7df5-4d24-8635-3b7c0bfa02d6	Type 1	AKSHAT	9636286581	akshat.2226cseai1041@kiet.edu	da	2014-02-01 00:00:00	single	male	1	2025-05-01 14:40:42.536	2025-05-01 14:40:42.536
\.


--
-- Data for Name: InterestAccruedonNational; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."InterestAccruedonNational" (id, "purchaseDuration") FROM stdin;
\.


--
-- Data for Name: InterestAccruedonNationalList; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."InterestAccruedonNationalList" (id, "listNumber", "financeAct") FROM stdin;
\.


--
-- Data for Name: InterestOnKVP; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."InterestOnKVP" (id, year, rate) FROM stdin;
\.


--
-- Data for Name: InterestRatesAccrued; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."InterestRatesAccrued" (id, duration, rate) FROM stdin;
\.


--
-- Data for Name: Invoice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Invoice" (id, "invoiceNumber", type, "totalAmount", "totalGst", "stateOfSupply", cgst, sgst, igst, utgst, details, "extraDetails", "invoiceDate", "dueDate", "isInventory", "modeOfPayment", credit, "userId", "partyId", "gstNumber", "createdAt", "updatedAt", status) FROM stdin;
8abcd1e5-cc43-4de7-a15d-529b425dec06	INV-1747287711372	sales	389361	59394	23	29697	29697	0	0	111		2025-05-08 00:00:00	2025-05-05 00:00:00	t	credit	t	2	0b9dea01-99eb-44d9-9537-7479f3c011f9	23BNJPS3408M1ZP	2025-05-15 05:43:57.666	2025-05-15 05:43:57.666	unpaid
60e45e83-4ec9-41af-ab18-abaa446bb121	INV-1747288228162	purchase	37022	725	23	362	362	0	0	2		2025-05-09 00:00:00	2025-05-07 00:00:00	t	cash	f	2	a2f3bd7f-116a-4377-bc4a-177933712819	23BNJPS3408M1ZP	2025-05-15 05:52:04.998	2025-05-15 05:52:04.998	paid
fa792dfc-74ba-4d38-a373-e4a5a9862a03	INV-1747312249973	sales	486465	74206	23	37103	37103	0	0	fdfd		2025-05-15 00:00:00	2025-05-15 00:00:00	t	bank	f	2	848b3218-2c3a-4aaa-972a-1e800e07fb88	23BNJPS3408M1ZP	2025-05-15 12:32:22.5	2025-05-15 12:32:22.5	paid
fcf7c481-2366-4753-9e35-7da70a922e0d	INV-1747314071337	purchase	11818	2998	23	1499	1499	0	0	fefesf s fsf sf		2025-05-14 00:00:00	2025-05-14 00:00:00	t	cash	f	2	a2f3bd7f-116a-4377-bc4a-177933712819	23BNJPS3408M1ZP	2025-05-15 13:02:39.529	2025-05-15 13:02:39.529	paid
fa977160-bdac-4c8c-ba4e-d67b70c2ba03	INV-1747679949655	sales	472	72	23	36	36	0	0	fsffef		2025-05-19 00:00:00	2025-05-19 00:00:00	t	cash	f	2	0b9dea01-99eb-44d9-9537-7479f3c011f9	23BNJPS3408M1ZP	2025-05-19 18:39:58.975	2025-05-19 18:39:58.975	paid
\.


--
-- Data for Name: InvoiceItem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."InvoiceItem" (id, "itemId", quantity, discount, "taxPercent", "invoiceId") FROM stdin;
3c7cb98b-9166-416d-bbac-2effae6454ca	308c7d40-af6b-4469-a288-c5572dd993da	100	1.000000000000000000000000000000	18.000000000000000000000000000000	8abcd1e5-cc43-4de7-a15d-529b425dec06
305d0a92-ae9a-4185-8212-55a88218cd66	308c7d40-af6b-4469-a288-c5572dd993da	11	1.000000000000000000000000000000	2.000000000000000000000000000000	60e45e83-4ec9-41af-ab18-abaa446bb121
7c648fb0-ed20-4a35-b36d-26f7e75fbba7	4550805b-9e8e-4e35-bf98-1b8906e54043	133	7.000000000000000000000000000000	18.000000000000000000000000000000	fa792dfc-74ba-4d38-a373-e4a5a9862a03
3da49370-69db-44cb-80bf-ab8ae22de7d2	dbf97e74-4f8a-4fa0-a1e7-ace185797ffa	45	2.000000000000000000000000000000	34.000000000000000000000000000000	fcf7c481-2366-4753-9e35-7da70a922e0d
1c2e590e-7be2-4721-ac24-bf8c50e5a148	dbf97e74-4f8a-4fa0-a1e7-ace185797ffa	2	0.000000000000000000000000000000	18.000000000000000000000000000000	fa977160-bdac-4c8c-ba4e-d67b70c2ba03
\.


--
-- Data for Name: Item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Item" (id, "itemName", unit, price, "openingStock", "closingStock", "purchasePrice", cgst, sgst, igst, utgst, "taxExempted", description, "hsnCode", "categoryId", "supplierId", "userId", "createdAt", "updatedAt") FROM stdin;
dbf97e74-4f8a-4fa0-a1e7-ace185797ffa	sweet	pieces	200.000000000000000000000000000000	111.000000000000000000000000000000	11.000000000000000000000000000000	11.000000000000000000000000000000	1.000000000000000000000000000000	1.000000000000000000000000000000	1.000000000000000000000000000000	11.000000000000000000000000000000	f	4frrr	fsefefsefsefsf	\N	\N	2	2025-05-14 15:13:50.637	2025-05-14 15:13:50.637
4550805b-9e8e-4e35-bf98-1b8906e54043	Raj Bhog	pieces	3333.000000000000000000000000000000	144.000000000000000000000000000000	1111.000000000000000000000000000000	2222.000000000000000000000000000000	1.000000000000000000000000000000	1.000000000000000000000000000000	1.000000000000000000000000000000	1.000000000000000000000000000000	t	gg	fsefefse788	\N	\N	2	2025-05-14 15:26:39.753	2025-05-14 15:26:39.753
308c7d40-af6b-4469-a288-c5572dd993da	bhog	pieces	3333.000000000000000000000000000000	122.000000000000000000000000000000	333.000000000000000000000000000000	2222.000000000000000000000000000000	3.000000000000000000000000000000	1.000000000000000000000000000000	0.980000000000000000000000000000	2.000000000000000000000000000000	f	ggg	fsefefsefs	\N	\N	2	2025-05-14 15:27:11.978	2025-05-14 15:27:11.978
\.


--
-- Data for Name: JournalEntry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."JournalEntry" (id, "entryDate", description, "userId") FROM stdin;
\.


--
-- Data for Name: Ledger; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Ledger" (id, "ledgerName", "openingBalance", balance, "userId", "partyId", year, month, "ledgerType", "createdAt", "updatedAt") FROM stdin;
106001ea-3843-4a8e-937c-0abda971ea8b	Test Party	0.000000000000000000000000000000	0.000000000000000000000000000000	2	0b9dea01-99eb-44d9-9537-7479f3c011f9	2025	4	accountsPayable	2025-05-13 13:25:25.04	2025-05-13 13:25:25.04
5ab72852-fe04-4b89-b179-650cfa440314	RAM	0.000000000000000000000000000000	0.000000000000000000000000000000	2	cae1b058-d26d-4985-9fa8-38adb837c9d4	2025	4	accountsReceivable	2025-05-13 13:26:12.426	2025-05-13 13:26:12.426
8cf0c5c0-ba0a-458a-b942-22085a0c967d	RAM	0.000000000000000000000000000000	0.000000000000000000000000000000	2	\N	2025	4	accountsReceivable	2025-05-13 13:26:25.762	2025-05-13 13:26:25.762
4525a7dc-055d-440c-9c09-225a1b26b2b4	Ras	0.000000000000000000000000000000	0.000000000000000000000000000000	2	848b3218-2c3a-4aaa-972a-1e800e07fb88	2025	4	accountsReceivable	2025-05-14 10:31:43.09	2025-05-14 10:31:43.09
7067fed7-77af-45e9-8a45-3814dd01704f	Ras	0.000000000000000000000000000000	0.000000000000000000000000000000	2	\N	2025	4	accountsReceivable	2025-05-13 13:28:40.579	2025-05-13 13:28:40.579
1231dd2a-ef6a-413c-92c8-d88854634faa	Ras	0.000000000000000000000000000000	0.000000000000000000000000000000	2	\N	2025	4	accountsReceivable	2025-05-14 10:32:16.132	2025-05-14 10:32:16.132
0e7ad9c7-80f5-43a4-998a-a41096750c64	Ras	0.000000000000000000000000000000	0.000000000000000000000000000000	2	\N	2025	4	accountsReceivable	2025-05-14 10:33:37.024	2025-05-14 10:33:37.024
ec1f5773-269f-49fc-947c-b4208c101990	RAM	0.000000000000000000000000000000	0.000000000000000000000000000000	2	a2f3bd7f-116a-4377-bc4a-177933712819	2025	4	accountsReceivable	2025-05-14 15:24:03.189	2025-05-14 15:24:03.189
\.


--
-- Data for Name: Library; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Library" (id, pan, section, sub_section, subject, ao_order, itat_no, rsa_no, bench, appeal_no, appellant, respondent, appeal_type, appeal_filed_by, order_result, tribunal_order_date, assessment_year, judgment, conclusion, download, upload, "createdAt", "updatedAt") FROM stdin;
3	ABCDE1234F	143(3)	1	Assessment Proceedings	Order324	ITAT125	RSA327	Delhi Bench	APL001	Meera Saini	Deputy Commissioner of Income Tax	Individual	Respondent	Allowed	2025-05-01	2010-2011	The appeal was dismissed due to lack of substantial evidence	Favorable	https://example.com/download_7.pdf	https://example.com/upload_7.pdf	2025-05-11 01:21:17.222	2025-05-11 01:21:17.222
4	BNJPS3408M	145	5	jdw	Order323	ITAT122	RSA320	Chennai Bench	APL003	Rajiv Kumar	Deputy Commissioner	Firm	Appellant	Dismissed	2025-05-06	2010-2011	judgement	efeffwf wfwfw fwfwf	https://example.com/download_6.pdf	https://example.com/upload_6.pdf	2025-05-11 01:24:17.952	2025-05-11 01:24:17.952
\.


--
-- Data for Name: Loan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Loan" (id, type, name, "shortName", description, "maxAmount", "minAmount", interest, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: LoanApplication; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."LoanApplication" (id, "loanId", "loanAmount", "loanStatus", "applicantName", "applicantAge", "loanType", "applicantGender", nationality, description, salaried, "bankAccountId", phone, email, address, "permanentAddress", "userId", "agentId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: LoanDocument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."LoanDocument" (id, name, "shortName", mandatory, type, description, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Order" (id, services, status, price, gst, "orderTotal", "stateOfSupply", "userId") FROM stdin;
\.


--
-- Data for Name: Otp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Otp" (id, "createdAt", otp, "userId", used, deletedate) FROM stdin;
\.


--
-- Data for Name: PanAndITCodeByStatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PanAndITCodeByStatus" (id, status, "incomeTaxCode", "panCode") FROM stdin;
\.


--
-- Data for Name: PanAndITCodeByStatusList; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PanAndITCodeByStatusList" (id, "financialYear") FROM stdin;
\.


--
-- Data for Name: Party; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Party" (id, "partyName", type, gstin, pan, tan, upi, email, phone, address, "bankName", "bankAccountNumber", "bankIfsc", "bankBranch", "userId", "createdAt", "updatedAt") FROM stdin;
0b9dea01-99eb-44d9-9537-7479f3c011f9	Test Party	supplier	TEST123456789	\N	\N	\N	test@example.com	1234567890	\N	\N	\N	\N	\N	2	2025-05-13 13:25:25.04	2025-05-13 13:25:25.04
cae1b058-d26d-4985-9fa8-38adb837c9d4	RAM	customer	23BNJPS3408M1ZP		\N		akshatggggg@gmail.com	9636286581					Dalhi	2	2025-05-13 13:26:12.426	2025-05-13 13:26:12.426
848b3218-2c3a-4aaa-972a-1e800e07fb88	Ras	supplier	07BNJPS3408M1ZP	BNJPS3408M	\N	akshatg9636@okaxis	mukulbedi@yahoo.com	2323232323	dwdadaw ad a	fesfsf	21312312313133	efsefsefesf	Delhi	2	2025-05-14 10:31:43.09	2025-05-14 10:31:43.09
a2f3bd7f-116a-4377-bc4a-177933712819	RAM	customer	23BNJPS3408M1ZP	BNJPS3408M	\N	akshatg9636@okaxis	mukulbedi@yahoo.com	2323232323	rsgsrg	fesfsf	21312312313133	efsefsefesf	fsefse	2	2025-05-14 15:24:03.189	2025-05-14 15:24:03.189
\.


--
-- Data for Name: Payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Payment" (id, razorpay_order_id, razorpay_payment_id, status, "userId", "orderId") FROM stdin;
\.


--
-- Data for Name: Post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Post" (id, "userId", title, "contentHeading", "contentDescription", category, "imageUrl", "createdAt", "updatedAt") FROM stdin;
d0800245-8676-447f-9837-00ae6badf05b	1	Exploring Node.js Middleware	Mastering Middleware in Node.js	In this post, we discuss how middleware functions work in Express and how to build them effectively.	Backend Development	https://res.cloudinary.com/drl3vjskb/image/upload/v1745784300/dashboard/users/1/images/billG_1745784295057.png	2025-04-27 20:04:59.43	2025-04-27 20:04:59.43
c72c8201-0944-4587-94f4-d9152c47740a	1	Exploring Node.	Mastering Middleware in Node.	In this post, we discuss how middleware functions work in Express and how to build them effectively.	Backend Developme	https://res.cloudinary.com/drl3vjskb/image/upload/v1745786098/dashboard/users/1/images/billG_1745786093397.png	2025-04-27 20:34:57.802	2025-04-27 20:34:57.802
5d75bcf3-335f-4d61-bb4e-43d981907299	1	Exploring Node.	Mastering Middleware in Node.	In this post, we discuss how middleware functions work in Express and how to build them effectively.	Backend Developme	https://res.cloudinary.com/drl3vjskb/image/upload/v1745786103/dashboard/users/1/images/billG_1745786099194.png	2025-04-27 20:35:01.879	2025-04-27 20:35:01.879
c53210f9-8ef3-4dc1-945b-5df6f8ccdecf	1	Exploring Node	Mastering Middleware	In this post, we discuss how middleware functions work in Express and how to build them effectively.	Backend Developme	https://res.cloudinary.com/drl3vjskb/image/upload/v1745786124/dashboard/users/1/images/billG_1745786119854.png	2025-04-27 20:35:23.907	2025-04-27 20:35:23.907
47ff5cf9-dec9-43a2-a1a6-be899615655a	1	Explorin	Mastering Middlewar	In this post, we discuss how middleware functions work in Express and how to build them effectively.	Backend Develo	https://res.cloudinary.com/drl3vjskb/image/upload/v1746025785/dashboard/users/1/images/billG_1746025777701.png	2025-04-30 15:09:43.228	2025-04-30 15:09:43.228
746a2d34-a811-44ea-8a73-9939b0e928b3	1	Explorinde	Mastering Middleware	In this post, we discuss how middleware work in Express and how to build them effectively.	incometax	https://res.cloudinary.com/drl3vjskb/image/upload/v1745831862/dashboard/users/1/images/billG_1745831854163.png	2025-04-28 09:17:41.711	2025-04-28 09:17:41.711
7f819e6b-3479-45ed-9e79-04bd42fe9233	1	dww	dwd	dwdwd	companylaw	https://res.cloudinary.com/drl3vjskb/image/upload/v1746130140/dashboard/users/1/images/Whats_1746130138101.jpg	2025-05-01 20:09:00.79	2025-05-01 20:09:00.79
\.


--
-- Data for Name: RegisterServices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."RegisterServices" (id, "serviceId", "userId", "aadhaarCard", "panCard", "gstCertificate", photo) FROM stdin;
9	4	1	https://res.cloudinary.com/drl3vjskb/raw/upload/v1750107326/dashboard/users/1/images/calcu_1750107323279.pdf	https://res.cloudinary.com/drl3vjskb/raw/upload/v1750107326/dashboard/users/1/images/calcu_1750107323303.pdf	https://res.cloudinary.com/drl3vjskb/raw/upload/v1750107326/dashboard/users/1/images/calcu_1750107323304.pdf	https://res.cloudinary.com/drl3vjskb/image/upload/v1750107326/dashboard/users/1/images/calcu_1750107323306.pdf
\.


--
-- Data for Name: RegisterStartup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."RegisterStartup" (id, title, image, "priceWithGst", "aboutService", "userId", categories) FROM stdin;
2	PF Registration	/images/PF-Registration.jpeg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
3	FSSAI (Food License)	/images/fssai.png	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
4	DSC (Digital Signature Certification)	/images/dsc.jpeg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
5	Station8/NGO Registration	/images/MSME.jpeg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
6	Nidhi Company	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	companyRegistration
7	ESI Registration	/images/ESIRegistration.jpeg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
8	Partnership Registration	/images/partners.png	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
9	MSME Registration	/images/MSME.jpeg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
10	License Registration	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
11	ISO Registration	/images/iso.png	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
12	Professional Tax Registration	/images/professionalTax.jpeg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
13	Ration Card	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
14	Trust Registration	/images/MSME.jpeg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
15	Trademark Reply	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
16	Fire License Registration	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
17	IE License Partnership	/images/MSME.jpeg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
18	Trade Mark Renewal	/images/tradeMarkRenewal.png	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
19	Shop Act Registration	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
20	News Paper Registration	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
21	PF Monthly Return	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	returns
22	Registered Office Change	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	companyRegistration
23	Corporation License	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	companyRegistration
24	Company Registration	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	companyRegistration
25	Copy Right Registration	/images/copyrightRegistration.png	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
26	OPC Registration	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	companyRegistration
27	Association Formation	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
28	Copyright Reply	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
29	TDS Return Filing	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	returns
30	GST Registration	/images/gst.jpeg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
31	TAN Registration	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	companyRegistration
32	Advertisement Agency	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	registration
33	Audit 44AD	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	audits
34	LLP Registration	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	companyRegistration
35	Share Allotment	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	companyRegistration
36	ESI Monthly Return	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	returns
37	GST Return	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	returns
38	Audit 44AE	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	audits
40	Audit 44ADA	/logo.svg	999	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	4	audits
39	Accounting	/images/accounting.webp	809	PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\\n\\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\\n\\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.	1	audits
\.


--
-- Data for Name: Service; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Service" (id, "serviceName", "serviceType", "imgUrl", description, price, gst, documents, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: StatusWiseIncomeTaxCode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."StatusWiseIncomeTaxCode" (id, code, status) FROM stdin;
\.


--
-- Data for Name: Subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Subscriptions" (id, "userId", "amountForServices", txnid, pid, "subscriptionDuration", status, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: Transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Transaction" (id, "ledgerId", "journalEntryId", amount, "transactionType", "userId", date) FROM stdin;
\.


--
-- Data for Name: UploadedDocument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."UploadedDocument" (id, "userId", "fileName", "applicationId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id, "createdAt", email, password, "firstName", "middleName", "lastName", "fatherName", phone, gender, address, pin, aadhaar, pan, dob, avatar, "adminId", "superadminId", verified, "userType", ispanlinked, inventory) FROM stdin;
4	2025-04-22 20:19:21.881	akshatg9636@gmail.com	akshat@1234	Akshat	\N	\N	\N	\N	male	\N	\N	\N	\N	\N	\N	\N	\N	t	admin	f	f
8	2025-05-02 19:00:30.302	akshattestsd@gmail.com	$2b$10$dhchFtT6Hz1kHlLCrWVkVevqAyRWibmWf5uKeM.X.b4w8N8a88jjS	Saksaha		kumar	\N	9650771730	male	kwidw wjd q wj dw	213445	629575215993	BNJPS3408M	\N	https://res.cloudinary.com/drl3vjskb/image/upload/v1747076078/dashboard/users/8/images/GoldS_1747076074025.pdf	\N	\N	t	normal	f	f
2	2025-04-26 08:00:16.148	akshatggggg@gmail.com	$2b$10$NJXqdcDfo2Bs.G9BaaFOOudjQG5pEoTi.vdMJy66u5Gxp5DQy3Pre	Akshat		Gupta	\N	9636286581	male	da	213443	629575215993	BNJPS3408M	\N	\N	\N	\N	t	normal	f	t
1	2025-04-22 20:31:02.507	akshat.2226cseai1041@kiet.edu	$2b$10$C5DA57zNOt6S8ow4knEhb.dvCnbS4XEDAXcB8C7eS.TPVqTXgs3rC	Akshat		Gupta	\N	9436286581	male	efsefsrs	213443	629575215993	EAMPG4090Q	\N	\N	\N	1	t	superadmin	f	f
\.


--
-- Data for Name: UserProfile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."UserProfile" (id, pan, aadhaar, "firstName", "middleName", "lastName", email, phone, gender, address, pincode, "userId") FROM stdin;
\.


--
-- Data for Name: Visitor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Visitor" (id, count, "createdAt") FROM stdin;
2	378	2025-05-01 21:37:24.198
1	103	2025-05-01 21:37:24.198
\.


--
-- Data for Name: _AccountToInvoice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_AccountToInvoice" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _ApiServiceToSubscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_ApiServiceToSubscriptions" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _CartServices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_CartServices" ("A", "B") FROM stdin;
verifyaccounts	42241746-495d-448e-8206-00e3c733327f
login	42241746-495d-448e-8206-00e3c733327f
\.


--
-- Data for Name: _CartToRegisterServices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_CartToRegisterServices" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _CartToRegisterStartup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_CartToRegisterStartup" ("A", "B") FROM stdin;
42241746-495d-448e-8206-00e3c733327f	30
42241746-495d-448e-8206-00e3c733327f	3
42241746-495d-448e-8206-00e3c733327f	16
42241746-495d-448e-8206-00e3c733327f	12
a8faa7ae-6ade-4811-a07e-ccacb0ed10cb	3
a8faa7ae-6ade-4811-a07e-ccacb0ed10cb	2
a8faa7ae-6ade-4811-a07e-ccacb0ed10cb	9
\.


--
-- Data for Name: _CostInflationIndexToCostInflationList; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_CostInflationIndexToCostInflationList" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _CountryCodeToCountryCodeList; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_CountryCodeToCountryCodeList" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _InterestAccruedonNationalToInterestAccruedonNationalList; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_InterestAccruedonNationalToInterestAccruedonNationalList" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _InterestAccruedonNationalToInterestRatesAccrued; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_InterestAccruedonNationalToInterestRatesAccrued" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _LoanDocumentToUploadedDocument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_LoanDocumentToUploadedDocument" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _LoanToLoanDocument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_LoanToLoanDocument" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _PanAndITCodeByStatusToPanAndITCodeByStatusList; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_PanAndITCodeByStatusToPanAndITCodeByStatusList" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _RegisterServicesToSubscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_RegisterServicesToSubscriptions" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _RegisterStartupToSubscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."_RegisterStartupToSubscriptions" ("A", "B") FROM stdin;
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
509ddef0-ac06-4b9e-aae7-fc0d0d87cd89	7c1091d949fc7d1e505f4e74a3190ed164fde39f08abdbbf1caf57f06c29f153	2025-04-22 20:19:22.751521+00	20241205063043_new	\N	\N	2025-04-22 20:19:21.878001+00	1
4ac4e5d7-5adf-42f3-9400-4a8554de70ec	fccd9ad43a7e1ec6c018f60b0e41169b118e5ad2fc8002990c677536448cf2db	2025-04-22 20:19:22.763922+00	20241205170443_panstqatus	\N	\N	2025-04-22 20:19:22.755776+00	1
6d0d86d4-b842-4f85-bf9a-fe529346a1f5	f4d14aeba8a295b9313948db661a90b60842bd1a60a0af4e314efc9cc62d7a07	2025-04-22 20:19:22.777759+00	20241205174313_inventory	\N	\N	2025-04-22 20:19:22.769573+00	1
d6a52207-0616-4cf7-a426-9d8a6499d6f9	7bc4b61bfca7e816e207d1e5ead5de24b9665a8528ac5e8989973f6d7e7b3e39	2025-04-22 20:19:22.792105+00	20241207130901_otp	\N	\N	2025-04-22 20:19:22.783993+00	1
f2e7bdb4-a1e8-4be7-accb-666c59cdeb11	30064672dd3cbcc87efe00d7e8c4e3ab05b6f81fe8c17f8b25bd8497e47715ef	2025-04-22 20:19:22.804789+00	20241210094403_categorytype	\N	\N	2025-04-22 20:19:22.796718+00	1
f3fc12c4-71dd-4470-818d-602a8cbc2091	a2e578993ace57b5e5a8a5751662c84cd138b44b3ebb42fef3b4bf9a7068705d	2025-04-22 20:19:22.818127+00	20241210131358_htao	\N	\N	2025-04-22 20:19:22.809481+00	1
2a29ece9-16ef-418d-89ec-3c9cc82a5294	5d47f94338409b38895a67010a334ccfed82a3b77c98e8f3ba9a4205039e5391	2025-04-22 20:19:22.845359+00	20250115022413_	\N	\N	2025-04-22 20:19:22.822974+00	1
695df01f-dc0a-40c2-9a1e-14519c2f4385	df118c1c59daaae4bd3c6e3899f0a128d55d80a3b223f2123468f2da95ee08d2	2025-04-22 20:19:22.857572+00	20250115023217_y	\N	\N	2025-04-22 20:19:22.849931+00	1
f32282ea-afb6-4f8a-a7d1-2fab0368bd19	acf8bdf24438c95c77492615f896703d0d5bf0ccae4422d14e2335ed35a1eab4	2025-04-22 20:19:22.869446+00	20250313073055_test	\N	\N	2025-04-22 20:19:22.861785+00	1
3742064e-3fcf-4b92-92bd-a9e4e35c24b3	3bf70c56f6d5493d7358f60fd10f1594dded0c8d7915624d44213e5987447cbf	2025-04-22 20:19:22.893255+00	20250313074816_test	\N	\N	2025-04-22 20:19:22.874059+00	1
71af8296-fe42-4c7d-8c04-124a05307c8c	bb958d2f48d87abeea3fe5d93e05c196313354b33bc7ad7f756b926ff7a249aa	2025-04-22 20:19:22.920016+00	20250313075338_add_missing_models	\N	\N	2025-04-22 20:19:22.89782+00	1
0526a3d8-8df0-44fb-9910-dad28c291b69	6524d7468f40e81dbaf03836a1040da1cfab07b812f7bb9e158eb7f8033198d4	2025-04-22 20:19:28.012665+00	20250422201927_add_category_to_cart	\N	\N	2025-04-22 20:19:27.988115+00	1
\.


--
-- Data for Name: gstr1_12HSN; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."gstr1_12HSN" (id, "userId", sr_no, pos, taxable_value, rate, supply_type, cess, igst, cgst, sgst) FROM stdin;
\.


--
-- Name: Billpayable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Billpayable_id_seq"', 1, false);


--
-- Name: Billrecieve_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Billrecieve_id_seq"', 1, false);


--
-- Name: BusinessProfile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."BusinessProfile_id_seq"', 4, true);


--
-- Name: Career_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Career_id_seq"', 8, true);


--
-- Name: ContactUs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ContactUs_id_seq"', 4, true);


--
-- Name: DepreciationTable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."DepreciationTable_id_seq"', 1, false);


--
-- Name: Gstr1_11A2A2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gstr1_11A2A2_id_seq"', 1, false);


--
-- Name: Gstr1_11B1B2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gstr1_11B1B2_id_seq"', 1, false);


--
-- Name: Gstr1_4A_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gstr1_4A_id_seq"', 1, false);


--
-- Name: Gstr1_5A_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gstr1_5A_id_seq"', 1, false);


--
-- Name: Gstr1_5A_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gstr1_5A_item_id_seq"', 1, false);


--
-- Name: Gstr1_6A_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gstr1_6A_id_seq"', 1, false);


--
-- Name: Gstr1_6A_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gstr1_6A_item_id_seq"', 1, false);


--
-- Name: Gstr1_7B_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gstr1_7B_id_seq"', 1, false);


--
-- Name: Gstr1_8ABCD_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gstr1_8ABCD_id_seq"', 1, false);


--
-- Name: Gstr1_9B_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gstr1_9B_id_seq"', 1, false);


--
-- Name: Gstr1_9B_un_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Gstr1_9B_un_id_seq"', 1, false);


--
-- Name: InterestOnKVP_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."InterestOnKVP_id_seq"', 1, false);


--
-- Name: Library_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Library_id_seq"', 4, true);


--
-- Name: Order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Order_id_seq"', 1, false);


--
-- Name: Otp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Otp_id_seq"', 8, true);


--
-- Name: RegisterServices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."RegisterServices_id_seq"', 9, true);


--
-- Name: RegisterStartup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."RegisterStartup_id_seq"', 24, true);


--
-- Name: StatusWiseIncomeTaxCode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."StatusWiseIncomeTaxCode_id_seq"', 1, false);


--
-- Name: UserProfile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."UserProfile_id_seq"', 1, false);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_id_seq"', 9, true);


--
-- Name: Visitor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Visitor_id_seq"', 2, true);


--
-- Name: gstr1_12HSN_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."gstr1_12HSN_id_seq"', 1, false);


--
-- Name: About About_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."About"
    ADD CONSTRAINT "About_pkey" PRIMARY KEY (id);


--
-- Name: Account Account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_pkey" PRIMARY KEY (id);


--
-- Name: Agent Agent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Agent"
    ADD CONSTRAINT "Agent_pkey" PRIMARY KEY (id);


--
-- Name: ApiService ApiService_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ApiService"
    ADD CONSTRAINT "ApiService_pkey" PRIMARY KEY (id);


--
-- Name: BankDetails BankDetails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BankDetails"
    ADD CONSTRAINT "BankDetails_pkey" PRIMARY KEY (id);


--
-- Name: Billpayable Billpayable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Billpayable"
    ADD CONSTRAINT "Billpayable_pkey" PRIMARY KEY (id);


--
-- Name: Billrecieve Billrecieve_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Billrecieve"
    ADD CONSTRAINT "Billrecieve_pkey" PRIMARY KEY (id);


--
-- Name: BusinessProfile BusinessProfile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BusinessProfile"
    ADD CONSTRAINT "BusinessProfile_pkey" PRIMARY KEY (id);


--
-- Name: Career Career_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Career"
    ADD CONSTRAINT "Career_pkey" PRIMARY KEY (id);


--
-- Name: Cart Cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Cart"
    ADD CONSTRAINT "Cart_pkey" PRIMARY KEY (id);


--
-- Name: Category Category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);


--
-- Name: Client Client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Client"
    ADD CONSTRAINT "Client_pkey" PRIMARY KEY (id);


--
-- Name: ContactUs ContactUs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ContactUs"
    ADD CONSTRAINT "ContactUs_pkey" PRIMARY KEY (id);


--
-- Name: CostInflationIndex CostInflationIndex_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CostInflationIndex"
    ADD CONSTRAINT "CostInflationIndex_pkey" PRIMARY KEY (id);


--
-- Name: CostInflationList CostInflationList_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CostInflationList"
    ADD CONSTRAINT "CostInflationList_pkey" PRIMARY KEY (id);


--
-- Name: CountryCodeList CountryCodeList_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CountryCodeList"
    ADD CONSTRAINT "CountryCodeList_pkey" PRIMARY KEY (id);


--
-- Name: CountryCode CountryCode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CountryCode"
    ADD CONSTRAINT "CountryCode_pkey" PRIMARY KEY (id);


--
-- Name: DepreciationTable DepreciationTable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."DepreciationTable"
    ADD CONSTRAINT "DepreciationTable_pkey" PRIMARY KEY (id);


--
-- Name: GoldAndSilver GoldAndSilver_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."GoldAndSilver"
    ADD CONSTRAINT "GoldAndSilver_pkey" PRIMARY KEY (id);


--
-- Name: Gstr1_11A2A2 Gstr1_11A2A2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_11A2A2"
    ADD CONSTRAINT "Gstr1_11A2A2_pkey" PRIMARY KEY (id);


--
-- Name: Gstr1_11B1B2 Gstr1_11B1B2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_11B1B2"
    ADD CONSTRAINT "Gstr1_11B1B2_pkey" PRIMARY KEY (id);


--
-- Name: Gstr1_4A Gstr1_4A_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_4A"
    ADD CONSTRAINT "Gstr1_4A_pkey" PRIMARY KEY (id);


--
-- Name: Gstr1_5A_item Gstr1_5A_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_5A_item"
    ADD CONSTRAINT "Gstr1_5A_item_pkey" PRIMARY KEY (id);


--
-- Name: Gstr1_5A Gstr1_5A_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_5A"
    ADD CONSTRAINT "Gstr1_5A_pkey" PRIMARY KEY (id);


--
-- Name: Gstr1_6A_item Gstr1_6A_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_6A_item"
    ADD CONSTRAINT "Gstr1_6A_item_pkey" PRIMARY KEY (id);


--
-- Name: Gstr1_6A Gstr1_6A_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_6A"
    ADD CONSTRAINT "Gstr1_6A_pkey" PRIMARY KEY (id);


--
-- Name: Gstr1_7B Gstr1_7B_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_7B"
    ADD CONSTRAINT "Gstr1_7B_pkey" PRIMARY KEY (id);


--
-- Name: Gstr1_8ABCD Gstr1_8ABCD_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_8ABCD"
    ADD CONSTRAINT "Gstr1_8ABCD_pkey" PRIMARY KEY (id);


--
-- Name: Gstr1_9B Gstr1_9B_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_9B"
    ADD CONSTRAINT "Gstr1_9B_pkey" PRIMARY KEY (id);


--
-- Name: Gstr1_9B_un Gstr1_9B_un_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_9B_un"
    ADD CONSTRAINT "Gstr1_9B_un_pkey" PRIMARY KEY (id);


--
-- Name: Insurance Insurance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Insurance"
    ADD CONSTRAINT "Insurance_pkey" PRIMARY KEY (id);


--
-- Name: InterestAccruedonNationalList InterestAccruedonNationalList_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InterestAccruedonNationalList"
    ADD CONSTRAINT "InterestAccruedonNationalList_pkey" PRIMARY KEY (id);


--
-- Name: InterestAccruedonNational InterestAccruedonNational_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InterestAccruedonNational"
    ADD CONSTRAINT "InterestAccruedonNational_pkey" PRIMARY KEY (id);


--
-- Name: InterestOnKVP InterestOnKVP_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InterestOnKVP"
    ADD CONSTRAINT "InterestOnKVP_pkey" PRIMARY KEY (id);


--
-- Name: InterestRatesAccrued InterestRatesAccrued_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InterestRatesAccrued"
    ADD CONSTRAINT "InterestRatesAccrued_pkey" PRIMARY KEY (id);


--
-- Name: InvoiceItem InvoiceItem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvoiceItem"
    ADD CONSTRAINT "InvoiceItem_pkey" PRIMARY KEY (id);


--
-- Name: Invoice Invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Invoice"
    ADD CONSTRAINT "Invoice_pkey" PRIMARY KEY (id);


--
-- Name: Item Item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Item"
    ADD CONSTRAINT "Item_pkey" PRIMARY KEY (id);


--
-- Name: JournalEntry JournalEntry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."JournalEntry"
    ADD CONSTRAINT "JournalEntry_pkey" PRIMARY KEY (id);


--
-- Name: Ledger Ledger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ledger"
    ADD CONSTRAINT "Ledger_pkey" PRIMARY KEY (id);


--
-- Name: Library Library_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Library"
    ADD CONSTRAINT "Library_pkey" PRIMARY KEY (id);


--
-- Name: LoanApplication LoanApplication_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LoanApplication"
    ADD CONSTRAINT "LoanApplication_pkey" PRIMARY KEY (id);


--
-- Name: LoanDocument LoanDocument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LoanDocument"
    ADD CONSTRAINT "LoanDocument_pkey" PRIMARY KEY (id);


--
-- Name: Loan Loan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Loan"
    ADD CONSTRAINT "Loan_pkey" PRIMARY KEY (id);


--
-- Name: Order Order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_pkey" PRIMARY KEY (id);


--
-- Name: Otp Otp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Otp"
    ADD CONSTRAINT "Otp_pkey" PRIMARY KEY (id);


--
-- Name: PanAndITCodeByStatusList PanAndITCodeByStatusList_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PanAndITCodeByStatusList"
    ADD CONSTRAINT "PanAndITCodeByStatusList_pkey" PRIMARY KEY (id);


--
-- Name: PanAndITCodeByStatus PanAndITCodeByStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PanAndITCodeByStatus"
    ADD CONSTRAINT "PanAndITCodeByStatus_pkey" PRIMARY KEY (id);


--
-- Name: Party Party_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Party"
    ADD CONSTRAINT "Party_pkey" PRIMARY KEY (id);


--
-- Name: Payment Payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_pkey" PRIMARY KEY (id);


--
-- Name: Post Post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_pkey" PRIMARY KEY (id);


--
-- Name: RegisterServices RegisterServices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RegisterServices"
    ADD CONSTRAINT "RegisterServices_pkey" PRIMARY KEY (id);


--
-- Name: RegisterStartup RegisterStartup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RegisterStartup"
    ADD CONSTRAINT "RegisterStartup_pkey" PRIMARY KEY (id);


--
-- Name: Service Service_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Service"
    ADD CONSTRAINT "Service_pkey" PRIMARY KEY (id);


--
-- Name: StatusWiseIncomeTaxCode StatusWiseIncomeTaxCode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."StatusWiseIncomeTaxCode"
    ADD CONSTRAINT "StatusWiseIncomeTaxCode_pkey" PRIMARY KEY (id);


--
-- Name: Subscriptions Subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Subscriptions"
    ADD CONSTRAINT "Subscriptions_pkey" PRIMARY KEY (id);


--
-- Name: Transaction Transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transaction"
    ADD CONSTRAINT "Transaction_pkey" PRIMARY KEY (id);


--
-- Name: UploadedDocument UploadedDocument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UploadedDocument"
    ADD CONSTRAINT "UploadedDocument_pkey" PRIMARY KEY (id);


--
-- Name: UserProfile UserProfile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserProfile"
    ADD CONSTRAINT "UserProfile_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: Visitor Visitor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Visitor"
    ADD CONSTRAINT "Visitor_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: gstr1_12HSN gstr1_12HSN_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."gstr1_12HSN"
    ADD CONSTRAINT "gstr1_12HSN_pkey" PRIMARY KEY (id);


--
-- Name: Agent_userId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Agent_userId_key" ON public."Agent" USING btree ("userId");


--
-- Name: BusinessProfile_userId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "BusinessProfile_userId_key" ON public."BusinessProfile" USING btree ("userId");


--
-- Name: Cart_userId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Cart_userId_key" ON public."Cart" USING btree ("userId");


--
-- Name: CostInflationList_listName_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "CostInflationList_listName_key" ON public."CostInflationList" USING btree ("listName");


--
-- Name: CountryCodeList_assessYear_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "CountryCodeList_assessYear_key" ON public."CountryCodeList" USING btree ("assessYear");


--
-- Name: Gstr1_11A2A2_sr_no_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Gstr1_11A2A2_sr_no_key" ON public."Gstr1_11A2A2" USING btree (sr_no);


--
-- Name: Gstr1_11B1B2_sr_no_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Gstr1_11B1B2_sr_no_key" ON public."Gstr1_11B1B2" USING btree (sr_no);


--
-- Name: Gstr1_5A_sr_no_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Gstr1_5A_sr_no_key" ON public."Gstr1_5A" USING btree (sr_no);


--
-- Name: Gstr1_6A_sr_no_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Gstr1_6A_sr_no_key" ON public."Gstr1_6A" USING btree (sr_no);


--
-- Name: Gstr1_7B_sr_no_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Gstr1_7B_sr_no_key" ON public."Gstr1_7B" USING btree (sr_no);


--
-- Name: Gstr1_8ABCD_sr_no_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Gstr1_8ABCD_sr_no_key" ON public."Gstr1_8ABCD" USING btree (sr_no);


--
-- Name: Gstr1_9B_sr_no_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Gstr1_9B_sr_no_key" ON public."Gstr1_9B" USING btree (sr_no);


--
-- Name: Gstr1_9B_un_sr_no_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Gstr1_9B_un_sr_no_key" ON public."Gstr1_9B_un" USING btree (sr_no);


--
-- Name: InterestAccruedonNationalList_listNumber_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "InterestAccruedonNationalList_listNumber_key" ON public."InterestAccruedonNationalList" USING btree ("listNumber");


--
-- Name: PanAndITCodeByStatusList_financialYear_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "PanAndITCodeByStatusList_financialYear_key" ON public."PanAndITCodeByStatusList" USING btree ("financialYear");


--
-- Name: PanAndITCodeByStatus_status_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "PanAndITCodeByStatus_status_key" ON public."PanAndITCodeByStatus" USING btree (status);


--
-- Name: RegisterServices_serviceId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "RegisterServices_serviceId_key" ON public."RegisterServices" USING btree ("serviceId");


--
-- Name: Subscriptions_txnid_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Subscriptions_txnid_key" ON public."Subscriptions" USING btree (txnid);


--
-- Name: UserProfile_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UserProfile_email_key" ON public."UserProfile" USING btree (email);


--
-- Name: UserProfile_userId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "UserProfile_userId_key" ON public."UserProfile" USING btree ("userId");


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: _AccountToInvoice_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_AccountToInvoice_AB_unique" ON public."_AccountToInvoice" USING btree ("A", "B");


--
-- Name: _AccountToInvoice_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_AccountToInvoice_B_index" ON public."_AccountToInvoice" USING btree ("B");


--
-- Name: _ApiServiceToSubscriptions_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_ApiServiceToSubscriptions_AB_unique" ON public."_ApiServiceToSubscriptions" USING btree ("A", "B");


--
-- Name: _ApiServiceToSubscriptions_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_ApiServiceToSubscriptions_B_index" ON public."_ApiServiceToSubscriptions" USING btree ("B");


--
-- Name: _CartServices_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_CartServices_AB_unique" ON public."_CartServices" USING btree ("A", "B");


--
-- Name: _CartServices_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_CartServices_B_index" ON public."_CartServices" USING btree ("B");


--
-- Name: _CartToRegisterServices_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_CartToRegisterServices_AB_unique" ON public."_CartToRegisterServices" USING btree ("A", "B");


--
-- Name: _CartToRegisterServices_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_CartToRegisterServices_B_index" ON public."_CartToRegisterServices" USING btree ("B");


--
-- Name: _CartToRegisterStartup_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_CartToRegisterStartup_AB_unique" ON public."_CartToRegisterStartup" USING btree ("A", "B");


--
-- Name: _CartToRegisterStartup_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_CartToRegisterStartup_B_index" ON public."_CartToRegisterStartup" USING btree ("B");


--
-- Name: _CostInflationIndexToCostInflationList_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_CostInflationIndexToCostInflationList_AB_unique" ON public."_CostInflationIndexToCostInflationList" USING btree ("A", "B");


--
-- Name: _CostInflationIndexToCostInflationList_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_CostInflationIndexToCostInflationList_B_index" ON public."_CostInflationIndexToCostInflationList" USING btree ("B");


--
-- Name: _CountryCodeToCountryCodeList_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_CountryCodeToCountryCodeList_AB_unique" ON public."_CountryCodeToCountryCodeList" USING btree ("A", "B");


--
-- Name: _CountryCodeToCountryCodeList_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_CountryCodeToCountryCodeList_B_index" ON public."_CountryCodeToCountryCodeList" USING btree ("B");


--
-- Name: _InterestAccruedonNationalToInterestAccruedonNationalLi_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_InterestAccruedonNationalToInterestAccruedonNationalLi_B_index" ON public."_InterestAccruedonNationalToInterestAccruedonNationalList" USING btree ("B");


--
-- Name: _InterestAccruedonNationalToInterestAccruedonNational_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_InterestAccruedonNationalToInterestAccruedonNational_AB_unique" ON public."_InterestAccruedonNationalToInterestAccruedonNationalList" USING btree ("A", "B");


--
-- Name: _InterestAccruedonNationalToInterestRatesAccrued_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_InterestAccruedonNationalToInterestRatesAccrued_AB_unique" ON public."_InterestAccruedonNationalToInterestRatesAccrued" USING btree ("A", "B");


--
-- Name: _InterestAccruedonNationalToInterestRatesAccrued_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_InterestAccruedonNationalToInterestRatesAccrued_B_index" ON public."_InterestAccruedonNationalToInterestRatesAccrued" USING btree ("B");


--
-- Name: _LoanDocumentToUploadedDocument_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_LoanDocumentToUploadedDocument_AB_unique" ON public."_LoanDocumentToUploadedDocument" USING btree ("A", "B");


--
-- Name: _LoanDocumentToUploadedDocument_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_LoanDocumentToUploadedDocument_B_index" ON public."_LoanDocumentToUploadedDocument" USING btree ("B");


--
-- Name: _LoanToLoanDocument_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_LoanToLoanDocument_AB_unique" ON public."_LoanToLoanDocument" USING btree ("A", "B");


--
-- Name: _LoanToLoanDocument_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_LoanToLoanDocument_B_index" ON public."_LoanToLoanDocument" USING btree ("B");


--
-- Name: _PanAndITCodeByStatusToPanAndITCodeByStatusList_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_PanAndITCodeByStatusToPanAndITCodeByStatusList_AB_unique" ON public."_PanAndITCodeByStatusToPanAndITCodeByStatusList" USING btree ("A", "B");


--
-- Name: _PanAndITCodeByStatusToPanAndITCodeByStatusList_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_PanAndITCodeByStatusToPanAndITCodeByStatusList_B_index" ON public."_PanAndITCodeByStatusToPanAndITCodeByStatusList" USING btree ("B");


--
-- Name: _RegisterServicesToSubscriptions_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_RegisterServicesToSubscriptions_AB_unique" ON public."_RegisterServicesToSubscriptions" USING btree ("A", "B");


--
-- Name: _RegisterServicesToSubscriptions_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_RegisterServicesToSubscriptions_B_index" ON public."_RegisterServicesToSubscriptions" USING btree ("B");


--
-- Name: _RegisterStartupToSubscriptions_AB_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "_RegisterStartupToSubscriptions_AB_unique" ON public."_RegisterStartupToSubscriptions" USING btree ("A", "B");


--
-- Name: _RegisterStartupToSubscriptions_B_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "_RegisterStartupToSubscriptions_B_index" ON public."_RegisterStartupToSubscriptions" USING btree ("B");


--
-- Name: gstr1_12HSN_sr_no_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "gstr1_12HSN_sr_no_key" ON public."gstr1_12HSN" USING btree (sr_no);


--
-- Name: Account Account_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Agent Agent_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Agent"
    ADD CONSTRAINT "Agent_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: BankDetails BankDetails_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BankDetails"
    ADD CONSTRAINT "BankDetails_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: BusinessProfile BusinessProfile_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."BusinessProfile"
    ADD CONSTRAINT "BusinessProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Cart Cart_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Cart"
    ADD CONSTRAINT "Cart_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Category Category_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Client Client_agentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Client"
    ADD CONSTRAINT "Client_agentId_fkey" FOREIGN KEY ("agentId") REFERENCES public."Agent"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Client Client_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Client"
    ADD CONSTRAINT "Client_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Gstr1_11A2A2 Gstr1_11A2A2_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_11A2A2"
    ADD CONSTRAINT "Gstr1_11A2A2_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Gstr1_11B1B2 Gstr1_11B1B2_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_11B1B2"
    ADD CONSTRAINT "Gstr1_11B1B2_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Gstr1_4A Gstr1_4A_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_4A"
    ADD CONSTRAINT "Gstr1_4A_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Gstr1_5A_item Gstr1_5A_item_gstr1_5A_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_5A_item"
    ADD CONSTRAINT "Gstr1_5A_item_gstr1_5A_id_fkey" FOREIGN KEY ("gstr1_5A_id") REFERENCES public."Gstr1_5A"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Gstr1_5A Gstr1_5A_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_5A"
    ADD CONSTRAINT "Gstr1_5A_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Gstr1_6A_item Gstr1_6A_item_gstr1_6A_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_6A_item"
    ADD CONSTRAINT "Gstr1_6A_item_gstr1_6A_id_fkey" FOREIGN KEY ("gstr1_6A_id") REFERENCES public."Gstr1_6A"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Gstr1_6A Gstr1_6A_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_6A"
    ADD CONSTRAINT "Gstr1_6A_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Gstr1_7B Gstr1_7B_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_7B"
    ADD CONSTRAINT "Gstr1_7B_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Gstr1_8ABCD Gstr1_8ABCD_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_8ABCD"
    ADD CONSTRAINT "Gstr1_8ABCD_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Gstr1_9B_un Gstr1_9B_un_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_9B_un"
    ADD CONSTRAINT "Gstr1_9B_un_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Gstr1_9B Gstr1_9B_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gstr1_9B"
    ADD CONSTRAINT "Gstr1_9B_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Insurance Insurance_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Insurance"
    ADD CONSTRAINT "Insurance_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: InvoiceItem InvoiceItem_invoiceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvoiceItem"
    ADD CONSTRAINT "InvoiceItem_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES public."Invoice"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: InvoiceItem InvoiceItem_itemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."InvoiceItem"
    ADD CONSTRAINT "InvoiceItem_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES public."Item"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Invoice Invoice_partyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Invoice"
    ADD CONSTRAINT "Invoice_partyId_fkey" FOREIGN KEY ("partyId") REFERENCES public."Party"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Invoice Invoice_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Invoice"
    ADD CONSTRAINT "Invoice_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Item Item_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Item"
    ADD CONSTRAINT "Item_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Item Item_supplierId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Item"
    ADD CONSTRAINT "Item_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES public."Party"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Item Item_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Item"
    ADD CONSTRAINT "Item_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: JournalEntry JournalEntry_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."JournalEntry"
    ADD CONSTRAINT "JournalEntry_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Ledger Ledger_partyId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ledger"
    ADD CONSTRAINT "Ledger_partyId_fkey" FOREIGN KEY ("partyId") REFERENCES public."Party"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Ledger Ledger_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Ledger"
    ADD CONSTRAINT "Ledger_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: LoanApplication LoanApplication_agentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LoanApplication"
    ADD CONSTRAINT "LoanApplication_agentId_fkey" FOREIGN KEY ("agentId") REFERENCES public."Agent"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: LoanApplication LoanApplication_bankAccountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LoanApplication"
    ADD CONSTRAINT "LoanApplication_bankAccountId_fkey" FOREIGN KEY ("bankAccountId") REFERENCES public."BankDetails"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: LoanApplication LoanApplication_loanId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LoanApplication"
    ADD CONSTRAINT "LoanApplication_loanId_fkey" FOREIGN KEY ("loanId") REFERENCES public."Loan"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: LoanApplication LoanApplication_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."LoanApplication"
    ADD CONSTRAINT "LoanApplication_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Order Order_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order"
    ADD CONSTRAINT "Order_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Otp Otp_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Otp"
    ADD CONSTRAINT "Otp_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Party Party_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Party"
    ADD CONSTRAINT "Party_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Payment Payment_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Post Post_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Post"
    ADD CONSTRAINT "Post_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: RegisterServices RegisterServices_serviceId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RegisterServices"
    ADD CONSTRAINT "RegisterServices_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES public."RegisterStartup"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: RegisterServices RegisterServices_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RegisterServices"
    ADD CONSTRAINT "RegisterServices_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: RegisterStartup RegisterStartup_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."RegisterStartup"
    ADD CONSTRAINT "RegisterStartup_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Subscriptions Subscriptions_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Subscriptions"
    ADD CONSTRAINT "Subscriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Transaction Transaction_journalEntryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transaction"
    ADD CONSTRAINT "Transaction_journalEntryId_fkey" FOREIGN KEY ("journalEntryId") REFERENCES public."JournalEntry"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Transaction Transaction_ledgerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transaction"
    ADD CONSTRAINT "Transaction_ledgerId_fkey" FOREIGN KEY ("ledgerId") REFERENCES public."Ledger"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Transaction Transaction_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transaction"
    ADD CONSTRAINT "Transaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: UploadedDocument UploadedDocument_applicationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UploadedDocument"
    ADD CONSTRAINT "UploadedDocument_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES public."LoanApplication"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: UploadedDocument UploadedDocument_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UploadedDocument"
    ADD CONSTRAINT "UploadedDocument_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: UserProfile UserProfile_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."UserProfile"
    ADD CONSTRAINT "UserProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: _AccountToInvoice _AccountToInvoice_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_AccountToInvoice"
    ADD CONSTRAINT "_AccountToInvoice_A_fkey" FOREIGN KEY ("A") REFERENCES public."Account"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _AccountToInvoice _AccountToInvoice_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_AccountToInvoice"
    ADD CONSTRAINT "_AccountToInvoice_B_fkey" FOREIGN KEY ("B") REFERENCES public."Invoice"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _ApiServiceToSubscriptions _ApiServiceToSubscriptions_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_ApiServiceToSubscriptions"
    ADD CONSTRAINT "_ApiServiceToSubscriptions_A_fkey" FOREIGN KEY ("A") REFERENCES public."ApiService"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _ApiServiceToSubscriptions _ApiServiceToSubscriptions_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_ApiServiceToSubscriptions"
    ADD CONSTRAINT "_ApiServiceToSubscriptions_B_fkey" FOREIGN KEY ("B") REFERENCES public."Subscriptions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CartServices _CartServices_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CartServices"
    ADD CONSTRAINT "_CartServices_A_fkey" FOREIGN KEY ("A") REFERENCES public."ApiService"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CartServices _CartServices_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CartServices"
    ADD CONSTRAINT "_CartServices_B_fkey" FOREIGN KEY ("B") REFERENCES public."Cart"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CartToRegisterServices _CartToRegisterServices_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CartToRegisterServices"
    ADD CONSTRAINT "_CartToRegisterServices_A_fkey" FOREIGN KEY ("A") REFERENCES public."Cart"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CartToRegisterServices _CartToRegisterServices_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CartToRegisterServices"
    ADD CONSTRAINT "_CartToRegisterServices_B_fkey" FOREIGN KEY ("B") REFERENCES public."RegisterServices"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CartToRegisterStartup _CartToRegisterStartup_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CartToRegisterStartup"
    ADD CONSTRAINT "_CartToRegisterStartup_A_fkey" FOREIGN KEY ("A") REFERENCES public."Cart"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CartToRegisterStartup _CartToRegisterStartup_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CartToRegisterStartup"
    ADD CONSTRAINT "_CartToRegisterStartup_B_fkey" FOREIGN KEY ("B") REFERENCES public."RegisterStartup"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CostInflationIndexToCostInflationList _CostInflationIndexToCostInflationList_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CostInflationIndexToCostInflationList"
    ADD CONSTRAINT "_CostInflationIndexToCostInflationList_A_fkey" FOREIGN KEY ("A") REFERENCES public."CostInflationIndex"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CostInflationIndexToCostInflationList _CostInflationIndexToCostInflationList_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CostInflationIndexToCostInflationList"
    ADD CONSTRAINT "_CostInflationIndexToCostInflationList_B_fkey" FOREIGN KEY ("B") REFERENCES public."CostInflationList"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CountryCodeToCountryCodeList _CountryCodeToCountryCodeList_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CountryCodeToCountryCodeList"
    ADD CONSTRAINT "_CountryCodeToCountryCodeList_A_fkey" FOREIGN KEY ("A") REFERENCES public."CountryCode"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _CountryCodeToCountryCodeList _CountryCodeToCountryCodeList_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_CountryCodeToCountryCodeList"
    ADD CONSTRAINT "_CountryCodeToCountryCodeList_B_fkey" FOREIGN KEY ("B") REFERENCES public."CountryCodeList"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _InterestAccruedonNationalToInterestAccruedonNationalList _InterestAccruedonNationalToInterestAccruedonNationalLis_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_InterestAccruedonNationalToInterestAccruedonNationalList"
    ADD CONSTRAINT "_InterestAccruedonNationalToInterestAccruedonNationalLis_A_fkey" FOREIGN KEY ("A") REFERENCES public."InterestAccruedonNational"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _InterestAccruedonNationalToInterestAccruedonNationalList _InterestAccruedonNationalToInterestAccruedonNationalLis_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_InterestAccruedonNationalToInterestAccruedonNationalList"
    ADD CONSTRAINT "_InterestAccruedonNationalToInterestAccruedonNationalLis_B_fkey" FOREIGN KEY ("B") REFERENCES public."InterestAccruedonNationalList"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _InterestAccruedonNationalToInterestRatesAccrued _InterestAccruedonNationalToInterestRatesAccrued_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_InterestAccruedonNationalToInterestRatesAccrued"
    ADD CONSTRAINT "_InterestAccruedonNationalToInterestRatesAccrued_A_fkey" FOREIGN KEY ("A") REFERENCES public."InterestAccruedonNational"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _InterestAccruedonNationalToInterestRatesAccrued _InterestAccruedonNationalToInterestRatesAccrued_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_InterestAccruedonNationalToInterestRatesAccrued"
    ADD CONSTRAINT "_InterestAccruedonNationalToInterestRatesAccrued_B_fkey" FOREIGN KEY ("B") REFERENCES public."InterestRatesAccrued"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _LoanDocumentToUploadedDocument _LoanDocumentToUploadedDocument_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_LoanDocumentToUploadedDocument"
    ADD CONSTRAINT "_LoanDocumentToUploadedDocument_A_fkey" FOREIGN KEY ("A") REFERENCES public."LoanDocument"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _LoanDocumentToUploadedDocument _LoanDocumentToUploadedDocument_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_LoanDocumentToUploadedDocument"
    ADD CONSTRAINT "_LoanDocumentToUploadedDocument_B_fkey" FOREIGN KEY ("B") REFERENCES public."UploadedDocument"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _LoanToLoanDocument _LoanToLoanDocument_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_LoanToLoanDocument"
    ADD CONSTRAINT "_LoanToLoanDocument_A_fkey" FOREIGN KEY ("A") REFERENCES public."Loan"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _LoanToLoanDocument _LoanToLoanDocument_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_LoanToLoanDocument"
    ADD CONSTRAINT "_LoanToLoanDocument_B_fkey" FOREIGN KEY ("B") REFERENCES public."LoanDocument"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _PanAndITCodeByStatusToPanAndITCodeByStatusList _PanAndITCodeByStatusToPanAndITCodeByStatusList_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_PanAndITCodeByStatusToPanAndITCodeByStatusList"
    ADD CONSTRAINT "_PanAndITCodeByStatusToPanAndITCodeByStatusList_A_fkey" FOREIGN KEY ("A") REFERENCES public."PanAndITCodeByStatus"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _PanAndITCodeByStatusToPanAndITCodeByStatusList _PanAndITCodeByStatusToPanAndITCodeByStatusList_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_PanAndITCodeByStatusToPanAndITCodeByStatusList"
    ADD CONSTRAINT "_PanAndITCodeByStatusToPanAndITCodeByStatusList_B_fkey" FOREIGN KEY ("B") REFERENCES public."PanAndITCodeByStatusList"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _RegisterServicesToSubscriptions _RegisterServicesToSubscriptions_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_RegisterServicesToSubscriptions"
    ADD CONSTRAINT "_RegisterServicesToSubscriptions_A_fkey" FOREIGN KEY ("A") REFERENCES public."RegisterServices"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _RegisterServicesToSubscriptions _RegisterServicesToSubscriptions_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_RegisterServicesToSubscriptions"
    ADD CONSTRAINT "_RegisterServicesToSubscriptions_B_fkey" FOREIGN KEY ("B") REFERENCES public."Subscriptions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _RegisterStartupToSubscriptions _RegisterStartupToSubscriptions_A_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_RegisterStartupToSubscriptions"
    ADD CONSTRAINT "_RegisterStartupToSubscriptions_A_fkey" FOREIGN KEY ("A") REFERENCES public."RegisterStartup"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: _RegisterStartupToSubscriptions _RegisterStartupToSubscriptions_B_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."_RegisterStartupToSubscriptions"
    ADD CONSTRAINT "_RegisterStartupToSubscriptions_B_fkey" FOREIGN KEY ("B") REFERENCES public."Subscriptions"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gstr1_12HSN gstr1_12HSN_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."gstr1_12HSN"
    ADD CONSTRAINT "gstr1_12HSN_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

