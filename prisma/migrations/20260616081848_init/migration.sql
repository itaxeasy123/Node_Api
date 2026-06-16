-- CreateEnum
CREATE TYPE "ItrInquiryStatus" AS ENUM ('pending', 'approved', 'rejected', 'paid');

-- CreateEnum
CREATE TYPE "UserType" AS ENUM ('admin', 'normal', 'agent', 'superadmin');

-- CreateEnum
CREATE TYPE "UserGender" AS ENUM ('male', 'female', 'other');

-- CreateEnum
CREATE TYPE "SubscriptionStatus" AS ENUM ('initiated', 'pending', 'success', 'failure', 'usercancelled', 'droppedF', 'bounced');

-- CreateEnum
CREATE TYPE "SubscriptionsDuration" AS ENUM ('monthly', 'quarterly', 'halfYealy', 'yearly');

-- CreateEnum
CREATE TYPE "CompanyRole" AS ENUM ('OWNER', 'ADMIN', 'ACCOUNTANT', 'VIEWER');

-- CreateEnum
CREATE TYPE "AccountNature" AS ENUM ('ASSET', 'LIABILITY', 'INCOME', 'EXPENSE');

-- CreateEnum
CREATE TYPE "ReportSectionType" AS ENUM ('TRADING', 'PROFIT_AND_LOSS', 'BALANCE_SHEET');

-- CreateEnum
CREATE TYPE "DrCr" AS ENUM ('DR', 'CR');

-- CreateEnum
CREATE TYPE "VoucherBaseType" AS ENUM ('PAYMENT', 'RECEIPT', 'CONTRA', 'SALES', 'PURCHASE', 'DEBIT_NOTE', 'CREDIT_NOTE', 'JOURNAL');

-- CreateEnum
CREATE TYPE "VoucherStatus" AS ENUM ('DRAFT', 'POSTED', 'REVERSED');

-- CreateEnum
CREATE TYPE "PartyType" AS ENUM ('customer', 'supplier');

-- CreateEnum
CREATE TYPE "ItemUnit" AS ENUM ('pieces', 'grams', 'kilograms', 'liters', 'milliliters', 'meters', 'centimeters', 'inches', 'feet', 'squareMeters', 'squareFeet', 'cubicMeters', 'cubicFeet', 'dozen', 'pack', 'carton', 'box', 'roll', 'bundle', 'pair', 'set');

-- CreateEnum
CREATE TYPE "InvoiceType" AS ENUM ('sales', 'purchase', 'sales_return', 'purchase_return');

-- CreateEnum
CREATE TYPE "ModeOfPayment" AS ENUM ('cash', 'bank', 'upi', 'credit');

-- CreateEnum
CREATE TYPE "InvoiceStatus" AS ENUM ('unpaid', 'paid', 'overdue');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('initiated', 'pending', 'success', 'failure', 'usercancelled', 'dropped', 'bounced');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('created', 'success', 'failed');

-- CreateEnum
CREATE TYPE "paymentStatus" AS ENUM ('paid', 'unpaid', 'overdue');

-- CreateEnum
CREATE TYPE "paymentMethod" AS ENUM ('cash', 'creditcard', 'upi', 'netbanking', 'cheque');

-- CreateEnum
CREATE TYPE "DocumentType" AS ENUM ('pdf', 'image', 'other');

-- CreateEnum
CREATE TYPE "LoanType" AS ENUM ('personal', 'education', 'home', 'business', 'car', 'property');

-- CreateEnum
CREATE TYPE "Nationality" AS ENUM ('resident', 'nri', 'foreign');

-- CreateEnum
CREATE TYPE "LoanStatus" AS ENUM ('pending', 'processing', 'review', 'accepted', 'rejected');

-- CreateEnum
CREATE TYPE "BankAccountType" AS ENUM ('savings', 'current', 'nri', 'fcnr', 'rd', 'fd', 'salary');

-- CreateEnum
CREATE TYPE "Under" AS ENUM ('sales', 'Revenue');

-- CreateEnum
CREATE TYPE "NAME" AS ENUM ('sales', 'cash', 'Rent', 'Expense');

-- CreateEnum
CREATE TYPE "CurrencyType" AS ENUM ('INR', 'USD', 'EUR', 'RUB');

-- CreateEnum
CREATE TYPE "StartupCategory" AS ENUM ('registration', 'companyRegistration', 'returns', 'audits');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "middleName" TEXT,
    "lastName" TEXT,
    "fatherName" TEXT,
    "phone" TEXT,
    "gender" "UserGender" NOT NULL,
    "address" TEXT,
    "pin" TEXT,
    "aadhaar" TEXT,
    "pan" TEXT,
    "dob" TIMESTAMP(3),
    "avatar" TEXT,
    "adminId" INTEGER,
    "superadminId" INTEGER,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "userType" "UserType" NOT NULL DEFAULT 'normal',
    "ispanlinked" BOOLEAN NOT NULL DEFAULT false,
    "inventory" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RefreshToken" (
    "id" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "revoked" BOOLEAN NOT NULL DEFAULT false,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RefreshToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProjectReport" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" INTEGER NOT NULL,
    "businessName" TEXT NOT NULL,
    "pdfUrl" TEXT NOT NULL,
    "pdfPublicId" TEXT,

    CONSTRAINT "ProjectReport_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ItrInquiry" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "aadhaarNumber" TEXT,
    "description" TEXT,
    "aadhaarUrl" TEXT,
    "panUrl" TEXT,
    "otherDocUrl" TEXT,
    "photoUrl" TEXT,
    "status" "ItrInquiryStatus" NOT NULL DEFAULT 'pending',
    "amount" DOUBLE PRECISION,
    "razorpayOrderId" TEXT,

    CONSTRAINT "ItrInquiry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Otp" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "otp" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "used" BOOLEAN NOT NULL DEFAULT false,
    "deletedate" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Otp_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserProfile" (
    "id" SERIAL NOT NULL,
    "pan" TEXT,
    "aadhaar" TEXT,
    "firstName" TEXT NOT NULL,
    "middleName" TEXT,
    "lastName" TEXT,
    "email" TEXT NOT NULL,
    "phone" TEXT,
    "gender" "UserGender" NOT NULL,
    "address" TEXT,
    "pincode" TEXT,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "UserProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BusinessProfile" (
    "id" SERIAL NOT NULL,
    "businessName" TEXT NOT NULL,
    "pan" TEXT,
    "tan" TEXT,
    "taxpayer_type" TEXT,
    "msme_number" TEXT,
    "status" TEXT,
    "ctb" TEXT,
    "gstin" TEXT,
    "statecode" TEXT,
    "street" TEXT,
    "city" TEXT,
    "dst" TEXT,
    "stcd" TEXT,
    "landmark" TEXT,
    "bankName" TEXT,
    "bankAccountNo" TEXT,
    "bankIfsc" TEXT,
    "bankBranch" TEXT,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isAddressVerified" BOOLEAN,
    "isBusinessNameVerified" BOOLEAN,
    "isGstinVerified" BOOLEAN,
    "isPanVerified" BOOLEAN,
    "isStateVerified" BOOLEAN,
    "pincode" TEXT,
    "state" TEXT,

    CONSTRAINT "BusinessProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Cart" (
    "id" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "category" TEXT,

    CONSTRAINT "Cart_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ApiService" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "overview" TEXT NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "upcoming" BOOLEAN NOT NULL,
    "endpoint" JSONB,
    "bodyParams" JSONB,
    "response" JSONB,
    "responseJSON" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "category" TEXT NOT NULL,

    CONSTRAINT "ApiService_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Subscriptions" (
    "id" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "amountForServices" DOUBLE PRECISION NOT NULL,
    "txnid" TEXT,
    "pid" TEXT,
    "note" TEXT,
    "subscriptionDuration" "SubscriptionsDuration" NOT NULL DEFAULT 'monthly',
    "status" "SubscriptionStatus" NOT NULL DEFAULT 'pending',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Company" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "gstin" TEXT,
    "pan" TEXT,
    "stateCode" TEXT,
    "fyStartMonth" INTEGER NOT NULL DEFAULT 4,
    "booksBeginDate" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CompanyUser" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "role" "CompanyRole" NOT NULL DEFAULT 'OWNER',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CompanyUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FiscalYear" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "isClosed" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "FiscalYear_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AccountGroup" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "parentGroupId" TEXT,
    "nature" "AccountNature" NOT NULL,
    "reportSection" "ReportSectionType" NOT NULL,
    "isSystem" BOOLEAN NOT NULL DEFAULT false,
    "path" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AccountGroup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LedgerAccount" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "openingBalance" DECIMAL(15,2) NOT NULL DEFAULT 0.0,
    "openingBalanceType" "DrCr" NOT NULL DEFAULT 'DR',
    "isSystem" BOOLEAN NOT NULL DEFAULT false,
    "partyId" TEXT,
    "bankName" TEXT,
    "bankAccountNo" TEXT,
    "bankIfsc" TEXT,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LedgerAccount_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoucherType" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "baseType" "VoucherBaseType" NOT NULL,
    "isSystem" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "VoucherType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoucherSequence" (
    "id" TEXT NOT NULL,
    "voucherTypeId" TEXT NOT NULL,
    "fiscalYearId" TEXT NOT NULL,
    "nextNumber" INTEGER NOT NULL DEFAULT 1,

    CONSTRAINT "VoucherSequence_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Voucher" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "fiscalYearId" TEXT NOT NULL,
    "voucherTypeId" TEXT NOT NULL,
    "voucherNo" TEXT,
    "voucherDate" TIMESTAMP(3) NOT NULL,
    "narration" TEXT,
    "partyId" TEXT,
    "status" "VoucherStatus" NOT NULL DEFAULT 'DRAFT',
    "reversalOfId" TEXT,
    "postedAt" TIMESTAMP(3),
    "createdById" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Voucher_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoucherLine" (
    "id" TEXT NOT NULL,
    "voucherId" TEXT NOT NULL,
    "lineNo" INTEGER NOT NULL,
    "ledgerId" TEXT NOT NULL,
    "debit" DECIMAL(15,2) NOT NULL DEFAULT 0.0,
    "credit" DECIMAL(15,2) NOT NULL DEFAULT 0.0,
    "narration" TEXT,

    CONSTRAINT "VoucherLine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VoucherGstLine" (
    "id" TEXT NOT NULL,
    "voucherId" TEXT NOT NULL,
    "description" TEXT,
    "hsnSac" TEXT,
    "taxableValue" DECIMAL(15,2) NOT NULL DEFAULT 0.0,
    "cgst" DECIMAL(15,2) NOT NULL DEFAULT 0.0,
    "sgst" DECIMAL(15,2) NOT NULL DEFAULT 0.0,
    "igst" DECIMAL(15,2) NOT NULL DEFAULT 0.0,
    "cess" DECIMAL(15,2) NOT NULL DEFAULT 0.0,

    CONSTRAINT "VoucherGstLine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BankReconciliation" (
    "id" TEXT NOT NULL,
    "voucherLineId" TEXT NOT NULL,
    "instrumentNo" TEXT,
    "instrumentDate" TIMESTAMP(3),
    "clearedOn" TIMESTAMP(3),
    "statementRef" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BankReconciliation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "tableName" TEXT NOT NULL,
    "recordId" TEXT NOT NULL,
    "before" JSONB,
    "after" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Party" (
    "id" TEXT NOT NULL,
    "partyName" TEXT NOT NULL,
    "type" "PartyType" NOT NULL,
    "gstin" TEXT,
    "pan" TEXT,
    "tan" TEXT,
    "upi" TEXT,
    "email" TEXT,
    "phone" TEXT,
    "address" TEXT,
    "bankName" TEXT,
    "bankAccountNumber" TEXT,
    "bankIfsc" TEXT,
    "bankBranch" TEXT,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Party_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StatusWiseIncomeTaxCode" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "status" TEXT NOT NULL,

    CONSTRAINT "StatusWiseIncomeTaxCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InterestOnKVP" (
    "id" SERIAL NOT NULL,
    "year" INTEGER NOT NULL,
    "rate" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "InterestOnKVP_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DepreciationTable" (
    "id" SERIAL NOT NULL,
    "assetType" TEXT NOT NULL,
    "depreciationRate" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "DepreciationTable_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Category" (
    "id" TEXT NOT NULL,
    "categoryName" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Item" (
    "id" TEXT NOT NULL,
    "itemName" TEXT NOT NULL,
    "unit" "ItemUnit" NOT NULL DEFAULT 'pieces',
    "price" DECIMAL(65,30) NOT NULL,
    "openingStock" DECIMAL(65,30),
    "closingStock" DECIMAL(65,30),
    "purchasePrice" DECIMAL(65,30),
    "cgst" DECIMAL(65,30),
    "sgst" DECIMAL(65,30),
    "igst" DECIMAL(65,30),
    "utgst" DECIMAL(65,30),
    "taxExempted" BOOLEAN NOT NULL DEFAULT false,
    "description" TEXT,
    "hsnCode" TEXT,
    "categoryId" TEXT,
    "supplierId" TEXT,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Invoice" (
    "id" TEXT NOT NULL,
    "invoiceNumber" TEXT,
    "type" "InvoiceType" NOT NULL,
    "totalAmount" DOUBLE PRECISION NOT NULL,
    "totalGst" DOUBLE PRECISION,
    "stateOfSupply" TEXT NOT NULL,
    "cgst" DOUBLE PRECISION,
    "sgst" DOUBLE PRECISION,
    "igst" DOUBLE PRECISION,
    "utgst" DOUBLE PRECISION,
    "details" TEXT,
    "extraDetails" TEXT,
    "invoiceDate" TIMESTAMP(3),
    "dueDate" TIMESTAMP(3),
    "isInventory" BOOLEAN,
    "modeOfPayment" "ModeOfPayment" NOT NULL,
    "credit" BOOLEAN NOT NULL,
    "userId" INTEGER NOT NULL,
    "partyId" TEXT NOT NULL,
    "gstNumber" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "InvoiceStatus" NOT NULL,

    CONSTRAINT "Invoice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InvoiceItem" (
    "id" TEXT NOT NULL,
    "itemId" TEXT,
    "quantity" INTEGER NOT NULL,
    "discount" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "taxPercent" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "invoiceId" TEXT NOT NULL,

    CONSTRAINT "InvoiceItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Service" (
    "id" TEXT NOT NULL,
    "imgUrl" TEXT,
    "description" TEXT,
    "price" DECIMAL(65,30) NOT NULL,
    "gst" DECIMAL(65,30) NOT NULL,
    "documents" JSONB NOT NULL,
    "serviceType" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Order" (
    "id" SERIAL NOT NULL,
    "services" JSONB NOT NULL,
    "status" "OrderStatus" NOT NULL DEFAULT 'pending',
    "price" DECIMAL(65,30) NOT NULL,
    "gst" DECIMAL(65,30) NOT NULL,
    "orderTotal" DECIMAL(65,30) NOT NULL,
    "stateOfSupply" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "Order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Payment" (
    "id" TEXT NOT NULL,
    "razorpay_order_id" TEXT NOT NULL,
    "razorpay_payment_id" TEXT NOT NULL,
    "status" "PaymentStatus" NOT NULL DEFAULT 'created',
    "userId" INTEGER NOT NULL,

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Library" (
    "id" SERIAL NOT NULL,
    "pan" TEXT NOT NULL,
    "section" TEXT NOT NULL,
    "sub_section" TEXT,
    "subject" TEXT NOT NULL,
    "ao_order" TEXT NOT NULL,
    "itat_no" TEXT NOT NULL,
    "rsa_no" TEXT,
    "bench" TEXT NOT NULL,
    "appeal_no" TEXT,
    "appellant" TEXT,
    "respondent" TEXT NOT NULL,
    "appeal_type" TEXT NOT NULL,
    "appeal_filed_by" TEXT NOT NULL,
    "order_result" TEXT NOT NULL,
    "tribunal_order_date" TEXT NOT NULL,
    "assessment_year" TEXT NOT NULL,
    "judgment" TEXT NOT NULL,
    "conclusion" TEXT NOT NULL,
    "download" TEXT NOT NULL,
    "upload" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Library_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Post" (
    "id" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "contentHeading" TEXT NOT NULL,
    "contentDescription" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "imageUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Post_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Career" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "pin" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "mobile" TEXT NOT NULL,
    "skills" TEXT NOT NULL,
    "gender" "UserGender" NOT NULL,
    "cv" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Career_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Billrecieve" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER,
    "billNumber" TEXT NOT NULL,
    "amount" TEXT NOT NULL,
    "tax" TEXT NOT NULL,
    "customerName" TEXT NOT NULL,
    "customerAddress" TEXT NOT NULL,
    "contact" TEXT NOT NULL,
    "itemQuantity" TEXT NOT NULL,
    "itemPrice" TEXT NOT NULL,
    "itemDescription" TEXT NOT NULL,
    "paymentStatus" "paymentStatus" NOT NULL DEFAULT 'unpaid',
    "paymentMethod" "paymentMethod" NOT NULL DEFAULT 'cash',
    "dueDate" TEXT NOT NULL,
    "comment" TEXT,

    CONSTRAINT "Billrecieve_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Billpayable" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER,
    "supplierName" TEXT NOT NULL,
    "supplierAddress" TEXT NOT NULL,
    "contact" TEXT NOT NULL,
    "billDate" TEXT NOT NULL,
    "dueDate" TEXT NOT NULL,
    "billAmount" TEXT NOT NULL,
    "billNumber" TEXT NOT NULL,
    "billDiscription" TEXT NOT NULL,
    "paymentMethod" "paymentMethod" NOT NULL DEFAULT 'cash',
    "transactionId" TEXT,
    "paymentDate" TEXT NOT NULL,
    "paymentAmount" TEXT NOT NULL,
    "tax" TEXT NOT NULL,
    "comment" TEXT,
    "invoiceNumber" TEXT,

    CONSTRAINT "Billpayable_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UploadedDocument" (
    "id" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "fileName" TEXT NOT NULL,
    "applicationId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UploadedDocument_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LoanDocument" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "shortName" TEXT NOT NULL,
    "mandatory" BOOLEAN NOT NULL DEFAULT false,
    "type" "DocumentType" NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LoanDocument_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Loan" (
    "id" TEXT NOT NULL,
    "type" "LoanType" NOT NULL,
    "name" TEXT NOT NULL,
    "shortName" TEXT,
    "description" TEXT,
    "maxAmount" DECIMAL(65,30),
    "minAmount" DECIMAL(65,30),
    "interest" DECIMAL(65,30) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Loan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LoanApplication" (
    "id" TEXT NOT NULL,
    "loanId" TEXT NOT NULL,
    "loanAmount" DECIMAL(65,30) NOT NULL,
    "loanStatus" "LoanStatus" NOT NULL DEFAULT 'pending',
    "applicantName" TEXT NOT NULL,
    "applicantAge" INTEGER NOT NULL,
    "loanType" "LoanType" NOT NULL,
    "applicantGender" "UserGender" NOT NULL,
    "nationality" "Nationality" NOT NULL,
    "description" TEXT NOT NULL,
    "salaried" BOOLEAN NOT NULL,
    "bankAccountId" TEXT NOT NULL,
    "phone" TEXT,
    "email" TEXT,
    "address" TEXT,
    "permanentAddress" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "agentId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LoanApplication_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BankDetails" (
    "id" TEXT NOT NULL,
    "accountHolderName" TEXT NOT NULL,
    "bankName" TEXT NOT NULL,
    "bankAccountNo" TEXT NOT NULL,
    "bankIfsc" TEXT NOT NULL,
    "bankBranch" TEXT NOT NULL,
    "bankAccountType" "BankAccountType" NOT NULL,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BankDetails_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Insurance" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "mobile" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "dob" TIMESTAMP(3) NOT NULL,
    "maritalStatus" TEXT NOT NULL,
    "gender" "UserGender" NOT NULL,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Insurance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Client" (
    "id" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "agentId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Client_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Agent" (
    "id" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Agent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Visitor" (
    "id" SERIAL NOT NULL,
    "count" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Visitor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RegisterStartup" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "image" TEXT NOT NULL,
    "priceWithGst" INTEGER,
    "aboutService" TEXT,
    "userId" INTEGER NOT NULL,
    "categories" "StartupCategory" NOT NULL,

    CONSTRAINT "RegisterStartup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RegisterServices" (
    "id" SERIAL NOT NULL,
    "serviceId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "aadhaarCard" TEXT NOT NULL,
    "panCard" TEXT NOT NULL,
    "gstCertificate" TEXT NOT NULL,
    "photo" TEXT NOT NULL,

    CONSTRAINT "RegisterServices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ContactUs" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "message" TEXT NOT NULL,

    CONSTRAINT "ContactUs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "About" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "position" TEXT NOT NULL,
    "image" TEXT NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "About_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gstr1_4A" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "LegalName" TEXT NOT NULL,
    "GSTN" TEXT NOT NULL,
    "pos" TEXT NOT NULL,
    "invoice_No" TEXT NOT NULL,
    "invoice_date" TEXT NOT NULL,
    "invoice_value" TEXT NOT NULL,
    "rate" TEXT NOT NULL,
    "nature" TEXT NOT NULL,
    "source" TEXT NOT NULL,
    "cgst" TEXT NOT NULL,
    "igst" TEXT NOT NULL,
    "sgst" TEXT NOT NULL,
    "supply_type" TEXT NOT NULL,
    "fy" TEXT NOT NULL,
    "period" TEXT NOT NULL,
    "taxpayer_type" TEXT NOT NULL,
    "trade_Name" TEXT,
    "processed_records" TEXT NOT NULL,
    "status" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Gstr1_4A_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gstr1_5A" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "sr_no" INTEGER NOT NULL,
    "pos" TEXT NOT NULL,
    "invoice_No" TEXT NOT NULL,
    "supply_type" TEXT NOT NULL,
    "invoice_value" TEXT NOT NULL,
    "invoice_date" TEXT NOT NULL,
    "total_taxable_value" TEXT NOT NULL,
    "integrated_tax" TEXT NOT NULL,
    "cess" TEXT NOT NULL,
    "total_invoice_value" TEXT NOT NULL,

    CONSTRAINT "Gstr1_5A_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gstr1_5A_item" (
    "id" SERIAL NOT NULL,
    "tax_rate" TEXT NOT NULL DEFAULT '0%',
    "Ammmout_of_tax" TEXT NOT NULL,
    "Igst" TEXT NOT NULL,
    "cess" TEXT NOT NULL,
    "gstr1_5A_id" INTEGER NOT NULL,

    CONSTRAINT "Gstr1_5A_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gstr1_6A" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "sr_no" INTEGER NOT NULL,
    "pos" TEXT NOT NULL,
    "invoice_no" TEXT NOT NULL,
    "supply_type" TEXT NOT NULL,
    "invoice_data" TEXT NOT NULL,
    "invoice_value" TEXT NOT NULL,
    "total_value" TEXT NOT NULL,
    "gst_payement" TEXT NOT NULL,
    "total_taxable_value" TEXT NOT NULL,
    "integarted_tax" TEXT NOT NULL,
    "cess" TEXT NOT NULL,

    CONSTRAINT "Gstr1_6A_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gstr1_6A_item" (
    "id" SERIAL NOT NULL,
    "pecentage" TEXT NOT NULL,
    "integrated_value" TEXT NOT NULL,
    "cgst" TEXT NOT NULL,
    "sgst" TEXT NOT NULL,
    "gstr1_6A_id" INTEGER NOT NULL,

    CONSTRAINT "Gstr1_6A_item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gstr1_7B" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "gstn" TEXT NOT NULL,
    "sr_no" INTEGER NOT NULL,
    "pos" TEXT NOT NULL,
    "taxable_value" TEXT NOT NULL,
    "supply_type" TEXT NOT NULL,
    "rate" TEXT NOT NULL,
    "central_tax" TEXT NOT NULL,
    "state_tax" TEXT NOT NULL,
    "cess" TEXT NOT NULL,
    "place_of_supply" TEXT NOT NULL,
    "total_taxable" TEXT NOT NULL,
    "integrated" TEXT NOT NULL,

    CONSTRAINT "Gstr1_7B_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gstr1_8ABCD" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "gstn" TEXT NOT NULL,
    "sr_no" INTEGER NOT NULL,
    "pos" TEXT NOT NULL,
    "taxable_value" TEXT NOT NULL,
    "supply_type" TEXT NOT NULL,
    "rate" TEXT NOT NULL,
    "central_tax" TEXT NOT NULL,
    "state_tax" TEXT NOT NULL,
    "cess" TEXT NOT NULL,

    CONSTRAINT "Gstr1_8ABCD_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gstr1_9B" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "gstn" TEXT NOT NULL,
    "sr_no" INTEGER NOT NULL,
    "recipient_name" TEXT NOT NULL,
    "name_as_master" TEXT NOT NULL,
    "debit_credit_note_no" TEXT NOT NULL,
    "debit_credit_note_date" TEXT NOT NULL,
    "state_tax" TEXT NOT NULL,
    "note_type" TEXT NOT NULL,
    "supply_type" TEXT NOT NULL,
    "items_details" TEXT NOT NULL,
    "select_rate" TEXT NOT NULL,
    "note_values" TEXT NOT NULL,
    "state_tax_rs" TEXT NOT NULL,
    "central_tax" TEXT NOT NULL,
    "cess" TEXT NOT NULL,

    CONSTRAINT "Gstr1_9B_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gstr1_9B_un" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "sr_no" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "debit_credit_note_no" TEXT NOT NULL,
    "debit_credit_note_date" TEXT NOT NULL,
    "state_tax" TEXT NOT NULL,
    "note_type" TEXT NOT NULL,
    "supply_type" TEXT NOT NULL,
    "item_details" TEXT NOT NULL,
    "select_rate" TEXT NOT NULL,
    "note_value" TEXT NOT NULL,
    "state_tax_rs" TEXT NOT NULL,
    "central_tax_rs" TEXT NOT NULL,
    "cess" TEXT NOT NULL,

    CONSTRAINT "Gstr1_9B_un_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gstr1_11A2A2" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "sr_no" INTEGER NOT NULL,
    "pos" TEXT NOT NULL,
    "supply" TEXT NOT NULL,
    "cess" TEXT NOT NULL,

    CONSTRAINT "Gstr1_11A2A2_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gstr1_11B1B2" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "sr_no" INTEGER NOT NULL,
    "pos" TEXT NOT NULL,
    "taxable_value" TEXT NOT NULL,
    "rate" TEXT NOT NULL,
    "supply_type" TEXT NOT NULL,
    "cess" TEXT NOT NULL,
    "igst" TEXT NOT NULL,
    "cgst" TEXT NOT NULL,
    "sgst" TEXT NOT NULL,

    CONSTRAINT "Gstr1_11B1B2_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gstr1_12HSN" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "sr_no" INTEGER NOT NULL,
    "pos" TEXT NOT NULL,
    "taxable_value" TEXT NOT NULL,
    "rate" TEXT NOT NULL,
    "supply_type" TEXT NOT NULL,
    "cess" TEXT NOT NULL,
    "igst" TEXT NOT NULL,
    "cgst" TEXT NOT NULL,
    "sgst" TEXT NOT NULL,

    CONSTRAINT "gstr1_12HSN_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CountryCodeList" (
    "id" TEXT NOT NULL,
    "assessYear" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CountryCodeList_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CountryCode" (
    "id" TEXT NOT NULL,
    "countryCode" TEXT NOT NULL,
    "countryName" TEXT NOT NULL,

    CONSTRAINT "CountryCode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GoldAndSilver" (
    "id" TEXT NOT NULL,
    "assessmentYear" TEXT NOT NULL,
    "stGoldRate24CPer10Grams" TEXT NOT NULL,
    "stSilverRateFor1Kg" TEXT NOT NULL,

    CONSTRAINT "GoldAndSilver_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CostInflationList" (
    "id" TEXT NOT NULL,
    "financeAct" TEXT NOT NULL,
    "listName" TEXT NOT NULL,

    CONSTRAINT "CostInflationList_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CostInflationIndex" (
    "id" TEXT NOT NULL,
    "financialYear" TEXT NOT NULL,
    "costInflationIndex" INTEGER NOT NULL,

    CONSTRAINT "CostInflationIndex_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PanAndITCodeByStatus" (
    "id" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "incomeTaxCode" INTEGER NOT NULL,
    "panCode" TEXT NOT NULL,

    CONSTRAINT "PanAndITCodeByStatus_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PanAndITCodeByStatusList" (
    "id" TEXT NOT NULL,
    "financialYear" TEXT NOT NULL,

    CONSTRAINT "PanAndITCodeByStatusList_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InterestRatesAccrued" (
    "id" TEXT NOT NULL,
    "duration" TEXT NOT NULL,
    "rate" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "InterestRatesAccrued_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InterestAccruedonNational" (
    "id" TEXT NOT NULL,
    "purchaseDuration" TEXT NOT NULL,

    CONSTRAINT "InterestAccruedonNational_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InterestAccruedonNationalList" (
    "id" TEXT NOT NULL,
    "listNumber" TEXT NOT NULL,
    "financeAct" TEXT NOT NULL,

    CONSTRAINT "InterestAccruedonNationalList_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CartToRegisterServices" (
    "A" TEXT NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_CartToRegisterStartup" (
    "A" TEXT NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_ApiServiceToSubscriptions" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_CartServices" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_LoanDocumentToUploadedDocument" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_LoanToLoanDocument" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_RegisterStartupToSubscriptions" (
    "A" INTEGER NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_RegisterServicesToSubscriptions" (
    "A" INTEGER NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_CountryCodeToCountryCodeList" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_CostInflationIndexToCostInflationList" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_PanAndITCodeByStatusToPanAndITCodeByStatusList" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_InterestAccruedonNationalToInterestAccruedonNationalList" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_InterestAccruedonNationalToInterestRatesAccrued" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_userType_idx" ON "User"("userType");

-- CreateIndex
CREATE INDEX "User_phone_idx" ON "User"("phone");

-- CreateIndex
CREATE INDEX "User_createdAt_idx" ON "User"("createdAt");

-- CreateIndex
CREATE INDEX "RefreshToken_userId_idx" ON "RefreshToken"("userId");

-- CreateIndex
CREATE INDEX "RefreshToken_expiresAt_idx" ON "RefreshToken"("expiresAt");

-- CreateIndex
CREATE INDEX "ProjectReport_userId_idx" ON "ProjectReport"("userId");

-- CreateIndex
CREATE INDEX "ProjectReport_createdAt_idx" ON "ProjectReport"("createdAt");

-- CreateIndex
CREATE INDEX "ItrInquiry_userId_idx" ON "ItrInquiry"("userId");

-- CreateIndex
CREATE INDEX "ItrInquiry_status_idx" ON "ItrInquiry"("status");

-- CreateIndex
CREATE INDEX "ItrInquiry_createdAt_idx" ON "ItrInquiry"("createdAt");

-- CreateIndex
CREATE INDEX "Otp_userId_idx" ON "Otp"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "UserProfile_email_key" ON "UserProfile"("email");

-- CreateIndex
CREATE UNIQUE INDEX "UserProfile_userId_key" ON "UserProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "BusinessProfile_userId_key" ON "BusinessProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Cart_userId_key" ON "Cart"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Subscriptions_txnid_key" ON "Subscriptions"("txnid");

-- CreateIndex
CREATE INDEX "Subscriptions_userId_createdAt_idx" ON "Subscriptions"("userId", "createdAt");

-- CreateIndex
CREATE INDEX "Subscriptions_createdAt_idx" ON "Subscriptions"("createdAt");

-- CreateIndex
CREATE INDEX "Subscriptions_status_idx" ON "Subscriptions"("status");

-- CreateIndex
CREATE INDEX "CompanyUser_userId_idx" ON "CompanyUser"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "CompanyUser_companyId_userId_key" ON "CompanyUser"("companyId", "userId");

-- CreateIndex
CREATE INDEX "FiscalYear_companyId_idx" ON "FiscalYear"("companyId");

-- CreateIndex
CREATE UNIQUE INDEX "FiscalYear_companyId_startDate_key" ON "FiscalYear"("companyId", "startDate");

-- CreateIndex
CREATE INDEX "AccountGroup_companyId_parentGroupId_idx" ON "AccountGroup"("companyId", "parentGroupId");

-- CreateIndex
CREATE INDEX "AccountGroup_companyId_path_idx" ON "AccountGroup"("companyId", "path");

-- CreateIndex
CREATE INDEX "AccountGroup_parentGroupId_idx" ON "AccountGroup"("parentGroupId");

-- CreateIndex
CREATE UNIQUE INDEX "AccountGroup_companyId_name_key" ON "AccountGroup"("companyId", "name");

-- CreateIndex
CREATE INDEX "LedgerAccount_companyId_groupId_idx" ON "LedgerAccount"("companyId", "groupId");

-- CreateIndex
CREATE INDEX "LedgerAccount_partyId_idx" ON "LedgerAccount"("partyId");

-- CreateIndex
CREATE INDEX "LedgerAccount_groupId_idx" ON "LedgerAccount"("groupId");

-- CreateIndex
CREATE UNIQUE INDEX "LedgerAccount_companyId_name_key" ON "LedgerAccount"("companyId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "VoucherType_companyId_code_key" ON "VoucherType"("companyId", "code");

-- CreateIndex
CREATE INDEX "VoucherSequence_fiscalYearId_idx" ON "VoucherSequence"("fiscalYearId");

-- CreateIndex
CREATE UNIQUE INDEX "VoucherSequence_voucherTypeId_fiscalYearId_key" ON "VoucherSequence"("voucherTypeId", "fiscalYearId");

-- CreateIndex
CREATE UNIQUE INDEX "Voucher_reversalOfId_key" ON "Voucher"("reversalOfId");

-- CreateIndex
CREATE INDEX "Voucher_companyId_voucherDate_idx" ON "Voucher"("companyId", "voucherDate");

-- CreateIndex
CREATE INDEX "Voucher_companyId_voucherTypeId_idx" ON "Voucher"("companyId", "voucherTypeId");

-- CreateIndex
CREATE INDEX "Voucher_companyId_status_idx" ON "Voucher"("companyId", "status");

-- CreateIndex
CREATE INDEX "Voucher_partyId_idx" ON "Voucher"("partyId");

-- CreateIndex
CREATE INDEX "Voucher_fiscalYearId_idx" ON "Voucher"("fiscalYearId");

-- CreateIndex
CREATE INDEX "Voucher_voucherTypeId_idx" ON "Voucher"("voucherTypeId");

-- CreateIndex
CREATE INDEX "Voucher_createdById_idx" ON "Voucher"("createdById");

-- CreateIndex
CREATE UNIQUE INDEX "Voucher_companyId_voucherNo_key" ON "Voucher"("companyId", "voucherNo");

-- CreateIndex
CREATE INDEX "VoucherLine_voucherId_idx" ON "VoucherLine"("voucherId");

-- CreateIndex
CREATE INDEX "VoucherLine_ledgerId_voucherId_idx" ON "VoucherLine"("ledgerId", "voucherId");

-- CreateIndex
CREATE INDEX "VoucherGstLine_voucherId_idx" ON "VoucherGstLine"("voucherId");

-- CreateIndex
CREATE UNIQUE INDEX "BankReconciliation_voucherLineId_key" ON "BankReconciliation"("voucherLineId");

-- CreateIndex
CREATE INDEX "AuditLog_companyId_tableName_recordId_idx" ON "AuditLog"("companyId", "tableName", "recordId");

-- CreateIndex
CREATE INDEX "AuditLog_userId_idx" ON "AuditLog"("userId");

-- CreateIndex
CREATE INDEX "Party_userId_idx" ON "Party"("userId");

-- CreateIndex
CREATE INDEX "Category_userId_idx" ON "Category"("userId");

-- CreateIndex
CREATE INDEX "Item_userId_idx" ON "Item"("userId");

-- CreateIndex
CREATE INDEX "Item_categoryId_idx" ON "Item"("categoryId");

-- CreateIndex
CREATE INDEX "Item_supplierId_idx" ON "Item"("supplierId");

-- CreateIndex
CREATE INDEX "Invoice_userId_idx" ON "Invoice"("userId");

-- CreateIndex
CREATE INDEX "Invoice_partyId_idx" ON "Invoice"("partyId");

-- CreateIndex
CREATE INDEX "Invoice_createdAt_idx" ON "Invoice"("createdAt");

-- CreateIndex
CREATE INDEX "InvoiceItem_invoiceId_idx" ON "InvoiceItem"("invoiceId");

-- CreateIndex
CREATE INDEX "InvoiceItem_itemId_idx" ON "InvoiceItem"("itemId");

-- CreateIndex
CREATE INDEX "Order_userId_idx" ON "Order"("userId");

-- CreateIndex
CREATE INDEX "Payment_userId_idx" ON "Payment"("userId");

-- CreateIndex
CREATE INDEX "Post_userId_idx" ON "Post"("userId");

-- CreateIndex
CREATE INDEX "Post_createdAt_idx" ON "Post"("createdAt");

-- CreateIndex
CREATE INDEX "Billrecieve_userId_idx" ON "Billrecieve"("userId");

-- CreateIndex
CREATE INDEX "Billpayable_userId_idx" ON "Billpayable"("userId");

-- CreateIndex
CREATE INDEX "UploadedDocument_userId_idx" ON "UploadedDocument"("userId");

-- CreateIndex
CREATE INDEX "UploadedDocument_applicationId_idx" ON "UploadedDocument"("applicationId");

-- CreateIndex
CREATE INDEX "LoanApplication_userId_idx" ON "LoanApplication"("userId");

-- CreateIndex
CREATE INDEX "LoanApplication_loanId_idx" ON "LoanApplication"("loanId");

-- CreateIndex
CREATE INDEX "LoanApplication_agentId_idx" ON "LoanApplication"("agentId");

-- CreateIndex
CREATE INDEX "LoanApplication_bankAccountId_idx" ON "LoanApplication"("bankAccountId");

-- CreateIndex
CREATE INDEX "LoanApplication_loanStatus_createdAt_idx" ON "LoanApplication"("loanStatus", "createdAt");

-- CreateIndex
CREATE INDEX "BankDetails_userId_idx" ON "BankDetails"("userId");

-- CreateIndex
CREATE INDEX "Insurance_userId_idx" ON "Insurance"("userId");

-- CreateIndex
CREATE INDEX "Insurance_createdAt_idx" ON "Insurance"("createdAt");

-- CreateIndex
CREATE INDEX "Client_userId_idx" ON "Client"("userId");

-- CreateIndex
CREATE INDEX "Client_agentId_idx" ON "Client"("agentId");

-- CreateIndex
CREATE UNIQUE INDEX "Agent_userId_key" ON "Agent"("userId");

-- CreateIndex
CREATE INDEX "RegisterStartup_userId_idx" ON "RegisterStartup"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "RegisterServices_serviceId_key" ON "RegisterServices"("serviceId");

-- CreateIndex
CREATE INDEX "RegisterServices_userId_idx" ON "RegisterServices"("userId");

-- CreateIndex
CREATE INDEX "RegisterServices_serviceId_idx" ON "RegisterServices"("serviceId");

-- CreateIndex
CREATE INDEX "Gstr1_4A_userId_idx" ON "Gstr1_4A"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_5A_sr_no_key" ON "Gstr1_5A"("sr_no");

-- CreateIndex
CREATE INDEX "Gstr1_5A_userId_idx" ON "Gstr1_5A"("userId");

-- CreateIndex
CREATE INDEX "Gstr1_5A_item_gstr1_5A_id_idx" ON "Gstr1_5A_item"("gstr1_5A_id");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_6A_sr_no_key" ON "Gstr1_6A"("sr_no");

-- CreateIndex
CREATE INDEX "Gstr1_6A_userId_idx" ON "Gstr1_6A"("userId");

-- CreateIndex
CREATE INDEX "Gstr1_6A_item_gstr1_6A_id_idx" ON "Gstr1_6A_item"("gstr1_6A_id");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_7B_sr_no_key" ON "Gstr1_7B"("sr_no");

-- CreateIndex
CREATE INDEX "Gstr1_7B_userId_idx" ON "Gstr1_7B"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_8ABCD_sr_no_key" ON "Gstr1_8ABCD"("sr_no");

-- CreateIndex
CREATE INDEX "Gstr1_8ABCD_userId_idx" ON "Gstr1_8ABCD"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_9B_sr_no_key" ON "Gstr1_9B"("sr_no");

-- CreateIndex
CREATE INDEX "Gstr1_9B_userId_idx" ON "Gstr1_9B"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_9B_un_sr_no_key" ON "Gstr1_9B_un"("sr_no");

-- CreateIndex
CREATE INDEX "Gstr1_9B_un_userId_idx" ON "Gstr1_9B_un"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_11A2A2_sr_no_key" ON "Gstr1_11A2A2"("sr_no");

-- CreateIndex
CREATE INDEX "Gstr1_11A2A2_userId_idx" ON "Gstr1_11A2A2"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_11B1B2_sr_no_key" ON "Gstr1_11B1B2"("sr_no");

-- CreateIndex
CREATE INDEX "Gstr1_11B1B2_userId_idx" ON "Gstr1_11B1B2"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "gstr1_12HSN_sr_no_key" ON "gstr1_12HSN"("sr_no");

-- CreateIndex
CREATE INDEX "gstr1_12HSN_userId_idx" ON "gstr1_12HSN"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "CountryCodeList_assessYear_key" ON "CountryCodeList"("assessYear");

-- CreateIndex
CREATE UNIQUE INDEX "CostInflationList_listName_key" ON "CostInflationList"("listName");

-- CreateIndex
CREATE UNIQUE INDEX "PanAndITCodeByStatus_status_key" ON "PanAndITCodeByStatus"("status");

-- CreateIndex
CREATE UNIQUE INDEX "PanAndITCodeByStatusList_financialYear_key" ON "PanAndITCodeByStatusList"("financialYear");

-- CreateIndex
CREATE UNIQUE INDEX "InterestAccruedonNationalList_listNumber_key" ON "InterestAccruedonNationalList"("listNumber");

-- CreateIndex
CREATE UNIQUE INDEX "_CartToRegisterServices_AB_unique" ON "_CartToRegisterServices"("A", "B");

-- CreateIndex
CREATE INDEX "_CartToRegisterServices_B_index" ON "_CartToRegisterServices"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_CartToRegisterStartup_AB_unique" ON "_CartToRegisterStartup"("A", "B");

-- CreateIndex
CREATE INDEX "_CartToRegisterStartup_B_index" ON "_CartToRegisterStartup"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_ApiServiceToSubscriptions_AB_unique" ON "_ApiServiceToSubscriptions"("A", "B");

-- CreateIndex
CREATE INDEX "_ApiServiceToSubscriptions_B_index" ON "_ApiServiceToSubscriptions"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_CartServices_AB_unique" ON "_CartServices"("A", "B");

-- CreateIndex
CREATE INDEX "_CartServices_B_index" ON "_CartServices"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_LoanDocumentToUploadedDocument_AB_unique" ON "_LoanDocumentToUploadedDocument"("A", "B");

-- CreateIndex
CREATE INDEX "_LoanDocumentToUploadedDocument_B_index" ON "_LoanDocumentToUploadedDocument"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_LoanToLoanDocument_AB_unique" ON "_LoanToLoanDocument"("A", "B");

-- CreateIndex
CREATE INDEX "_LoanToLoanDocument_B_index" ON "_LoanToLoanDocument"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_RegisterStartupToSubscriptions_AB_unique" ON "_RegisterStartupToSubscriptions"("A", "B");

-- CreateIndex
CREATE INDEX "_RegisterStartupToSubscriptions_B_index" ON "_RegisterStartupToSubscriptions"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_RegisterServicesToSubscriptions_AB_unique" ON "_RegisterServicesToSubscriptions"("A", "B");

-- CreateIndex
CREATE INDEX "_RegisterServicesToSubscriptions_B_index" ON "_RegisterServicesToSubscriptions"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_CountryCodeToCountryCodeList_AB_unique" ON "_CountryCodeToCountryCodeList"("A", "B");

-- CreateIndex
CREATE INDEX "_CountryCodeToCountryCodeList_B_index" ON "_CountryCodeToCountryCodeList"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_CostInflationIndexToCostInflationList_AB_unique" ON "_CostInflationIndexToCostInflationList"("A", "B");

-- CreateIndex
CREATE INDEX "_CostInflationIndexToCostInflationList_B_index" ON "_CostInflationIndexToCostInflationList"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_PanAndITCodeByStatusToPanAndITCodeByStatusList_AB_unique" ON "_PanAndITCodeByStatusToPanAndITCodeByStatusList"("A", "B");

-- CreateIndex
CREATE INDEX "_PanAndITCodeByStatusToPanAndITCodeByStatusList_B_index" ON "_PanAndITCodeByStatusToPanAndITCodeByStatusList"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_InterestAccruedonNationalToInterestAccruedonNational_AB_unique" ON "_InterestAccruedonNationalToInterestAccruedonNationalList"("A", "B");

-- CreateIndex
CREATE INDEX "_InterestAccruedonNationalToInterestAccruedonNationalLi_B_index" ON "_InterestAccruedonNationalToInterestAccruedonNationalList"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_InterestAccruedonNationalToInterestRatesAccrued_AB_unique" ON "_InterestAccruedonNationalToInterestRatesAccrued"("A", "B");

-- CreateIndex
CREATE INDEX "_InterestAccruedonNationalToInterestRatesAccrued_B_index" ON "_InterestAccruedonNationalToInterestRatesAccrued"("B");

-- AddForeignKey
ALTER TABLE "RefreshToken" ADD CONSTRAINT "RefreshToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectReport" ADD CONSTRAINT "ProjectReport_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItrInquiry" ADD CONSTRAINT "ItrInquiry_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Otp" ADD CONSTRAINT "Otp_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserProfile" ADD CONSTRAINT "UserProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BusinessProfile" ADD CONSTRAINT "BusinessProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Cart" ADD CONSTRAINT "Cart_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Subscriptions" ADD CONSTRAINT "Subscriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompanyUser" ADD CONSTRAINT "CompanyUser_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompanyUser" ADD CONSTRAINT "CompanyUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FiscalYear" ADD CONSTRAINT "FiscalYear_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccountGroup" ADD CONSTRAINT "AccountGroup_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccountGroup" ADD CONSTRAINT "AccountGroup_parentGroupId_fkey" FOREIGN KEY ("parentGroupId") REFERENCES "AccountGroup"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LedgerAccount" ADD CONSTRAINT "LedgerAccount_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LedgerAccount" ADD CONSTRAINT "LedgerAccount_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "AccountGroup"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LedgerAccount" ADD CONSTRAINT "LedgerAccount_partyId_fkey" FOREIGN KEY ("partyId") REFERENCES "Party"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoucherType" ADD CONSTRAINT "VoucherType_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoucherSequence" ADD CONSTRAINT "VoucherSequence_voucherTypeId_fkey" FOREIGN KEY ("voucherTypeId") REFERENCES "VoucherType"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoucherSequence" ADD CONSTRAINT "VoucherSequence_fiscalYearId_fkey" FOREIGN KEY ("fiscalYearId") REFERENCES "FiscalYear"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Voucher" ADD CONSTRAINT "Voucher_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Voucher" ADD CONSTRAINT "Voucher_fiscalYearId_fkey" FOREIGN KEY ("fiscalYearId") REFERENCES "FiscalYear"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Voucher" ADD CONSTRAINT "Voucher_voucherTypeId_fkey" FOREIGN KEY ("voucherTypeId") REFERENCES "VoucherType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Voucher" ADD CONSTRAINT "Voucher_partyId_fkey" FOREIGN KEY ("partyId") REFERENCES "Party"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Voucher" ADD CONSTRAINT "Voucher_reversalOfId_fkey" FOREIGN KEY ("reversalOfId") REFERENCES "Voucher"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Voucher" ADD CONSTRAINT "Voucher_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoucherLine" ADD CONSTRAINT "VoucherLine_voucherId_fkey" FOREIGN KEY ("voucherId") REFERENCES "Voucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoucherLine" ADD CONSTRAINT "VoucherLine_ledgerId_fkey" FOREIGN KEY ("ledgerId") REFERENCES "LedgerAccount"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VoucherGstLine" ADD CONSTRAINT "VoucherGstLine_voucherId_fkey" FOREIGN KEY ("voucherId") REFERENCES "Voucher"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BankReconciliation" ADD CONSTRAINT "BankReconciliation_voucherLineId_fkey" FOREIGN KEY ("voucherLineId") REFERENCES "VoucherLine"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Party" ADD CONSTRAINT "Party_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Category" ADD CONSTRAINT "Category_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Item" ADD CONSTRAINT "Item_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Item" ADD CONSTRAINT "Item_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES "Party"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Item" ADD CONSTRAINT "Item_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invoice" ADD CONSTRAINT "Invoice_partyId_fkey" FOREIGN KEY ("partyId") REFERENCES "Party"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invoice" ADD CONSTRAINT "Invoice_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InvoiceItem" ADD CONSTRAINT "InvoiceItem_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "Invoice"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InvoiceItem" ADD CONSTRAINT "InvoiceItem_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES "Item"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UploadedDocument" ADD CONSTRAINT "UploadedDocument_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "LoanApplication"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UploadedDocument" ADD CONSTRAINT "UploadedDocument_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LoanApplication" ADD CONSTRAINT "LoanApplication_agentId_fkey" FOREIGN KEY ("agentId") REFERENCES "Agent"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LoanApplication" ADD CONSTRAINT "LoanApplication_bankAccountId_fkey" FOREIGN KEY ("bankAccountId") REFERENCES "BankDetails"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LoanApplication" ADD CONSTRAINT "LoanApplication_loanId_fkey" FOREIGN KEY ("loanId") REFERENCES "Loan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LoanApplication" ADD CONSTRAINT "LoanApplication_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BankDetails" ADD CONSTRAINT "BankDetails_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Insurance" ADD CONSTRAINT "Insurance_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Client" ADD CONSTRAINT "Client_agentId_fkey" FOREIGN KEY ("agentId") REFERENCES "Agent"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Client" ADD CONSTRAINT "Client_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Agent" ADD CONSTRAINT "Agent_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RegisterStartup" ADD CONSTRAINT "RegisterStartup_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RegisterServices" ADD CONSTRAINT "RegisterServices_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "RegisterStartup"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RegisterServices" ADD CONSTRAINT "RegisterServices_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gstr1_4A" ADD CONSTRAINT "Gstr1_4A_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gstr1_5A" ADD CONSTRAINT "Gstr1_5A_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gstr1_5A_item" ADD CONSTRAINT "Gstr1_5A_item_gstr1_5A_id_fkey" FOREIGN KEY ("gstr1_5A_id") REFERENCES "Gstr1_5A"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gstr1_6A" ADD CONSTRAINT "Gstr1_6A_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gstr1_6A_item" ADD CONSTRAINT "Gstr1_6A_item_gstr1_6A_id_fkey" FOREIGN KEY ("gstr1_6A_id") REFERENCES "Gstr1_6A"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gstr1_7B" ADD CONSTRAINT "Gstr1_7B_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gstr1_8ABCD" ADD CONSTRAINT "Gstr1_8ABCD_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gstr1_9B" ADD CONSTRAINT "Gstr1_9B_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gstr1_9B_un" ADD CONSTRAINT "Gstr1_9B_un_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gstr1_11A2A2" ADD CONSTRAINT "Gstr1_11A2A2_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gstr1_11B1B2" ADD CONSTRAINT "Gstr1_11B1B2_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gstr1_12HSN" ADD CONSTRAINT "gstr1_12HSN_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CartToRegisterServices" ADD CONSTRAINT "_CartToRegisterServices_A_fkey" FOREIGN KEY ("A") REFERENCES "Cart"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CartToRegisterServices" ADD CONSTRAINT "_CartToRegisterServices_B_fkey" FOREIGN KEY ("B") REFERENCES "RegisterServices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CartToRegisterStartup" ADD CONSTRAINT "_CartToRegisterStartup_A_fkey" FOREIGN KEY ("A") REFERENCES "Cart"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CartToRegisterStartup" ADD CONSTRAINT "_CartToRegisterStartup_B_fkey" FOREIGN KEY ("B") REFERENCES "RegisterStartup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ApiServiceToSubscriptions" ADD CONSTRAINT "_ApiServiceToSubscriptions_A_fkey" FOREIGN KEY ("A") REFERENCES "ApiService"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ApiServiceToSubscriptions" ADD CONSTRAINT "_ApiServiceToSubscriptions_B_fkey" FOREIGN KEY ("B") REFERENCES "Subscriptions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CartServices" ADD CONSTRAINT "_CartServices_A_fkey" FOREIGN KEY ("A") REFERENCES "ApiService"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CartServices" ADD CONSTRAINT "_CartServices_B_fkey" FOREIGN KEY ("B") REFERENCES "Cart"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_LoanDocumentToUploadedDocument" ADD CONSTRAINT "_LoanDocumentToUploadedDocument_A_fkey" FOREIGN KEY ("A") REFERENCES "LoanDocument"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_LoanDocumentToUploadedDocument" ADD CONSTRAINT "_LoanDocumentToUploadedDocument_B_fkey" FOREIGN KEY ("B") REFERENCES "UploadedDocument"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_LoanToLoanDocument" ADD CONSTRAINT "_LoanToLoanDocument_A_fkey" FOREIGN KEY ("A") REFERENCES "Loan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_LoanToLoanDocument" ADD CONSTRAINT "_LoanToLoanDocument_B_fkey" FOREIGN KEY ("B") REFERENCES "LoanDocument"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_RegisterStartupToSubscriptions" ADD CONSTRAINT "_RegisterStartupToSubscriptions_A_fkey" FOREIGN KEY ("A") REFERENCES "RegisterStartup"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_RegisterStartupToSubscriptions" ADD CONSTRAINT "_RegisterStartupToSubscriptions_B_fkey" FOREIGN KEY ("B") REFERENCES "Subscriptions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_RegisterServicesToSubscriptions" ADD CONSTRAINT "_RegisterServicesToSubscriptions_A_fkey" FOREIGN KEY ("A") REFERENCES "RegisterServices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_RegisterServicesToSubscriptions" ADD CONSTRAINT "_RegisterServicesToSubscriptions_B_fkey" FOREIGN KEY ("B") REFERENCES "Subscriptions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CountryCodeToCountryCodeList" ADD CONSTRAINT "_CountryCodeToCountryCodeList_A_fkey" FOREIGN KEY ("A") REFERENCES "CountryCode"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CountryCodeToCountryCodeList" ADD CONSTRAINT "_CountryCodeToCountryCodeList_B_fkey" FOREIGN KEY ("B") REFERENCES "CountryCodeList"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CostInflationIndexToCostInflationList" ADD CONSTRAINT "_CostInflationIndexToCostInflationList_A_fkey" FOREIGN KEY ("A") REFERENCES "CostInflationIndex"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CostInflationIndexToCostInflationList" ADD CONSTRAINT "_CostInflationIndexToCostInflationList_B_fkey" FOREIGN KEY ("B") REFERENCES "CostInflationList"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PanAndITCodeByStatusToPanAndITCodeByStatusList" ADD CONSTRAINT "_PanAndITCodeByStatusToPanAndITCodeByStatusList_A_fkey" FOREIGN KEY ("A") REFERENCES "PanAndITCodeByStatus"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PanAndITCodeByStatusToPanAndITCodeByStatusList" ADD CONSTRAINT "_PanAndITCodeByStatusToPanAndITCodeByStatusList_B_fkey" FOREIGN KEY ("B") REFERENCES "PanAndITCodeByStatusList"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_InterestAccruedonNationalToInterestAccruedonNationalList" ADD CONSTRAINT "_InterestAccruedonNationalToInterestAccruedonNationalLis_A_fkey" FOREIGN KEY ("A") REFERENCES "InterestAccruedonNational"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_InterestAccruedonNationalToInterestAccruedonNationalList" ADD CONSTRAINT "_InterestAccruedonNationalToInterestAccruedonNationalLis_B_fkey" FOREIGN KEY ("B") REFERENCES "InterestAccruedonNationalList"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_InterestAccruedonNationalToInterestRatesAccrued" ADD CONSTRAINT "_InterestAccruedonNationalToInterestRatesAccrued_A_fkey" FOREIGN KEY ("A") REFERENCES "InterestAccruedonNational"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_InterestAccruedonNationalToInterestRatesAccrued" ADD CONSTRAINT "_InterestAccruedonNationalToInterestRatesAccrued_B_fkey" FOREIGN KEY ("B") REFERENCES "InterestRatesAccrued"("id") ON DELETE CASCADE ON UPDATE CASCADE;
