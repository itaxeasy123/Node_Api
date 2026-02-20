-- CreateEnum
CREATE TYPE "UserType" AS ENUM ('admin', 'normal', 'agent', 'superadmin');

-- CreateEnum
CREATE TYPE "UserGender" AS ENUM ('male', 'female', 'other');

-- CreateEnum
CREATE TYPE "SubscriptionStatus" AS ENUM ('initiated', 'pending', 'success', 'failure', 'usercancelled', 'dropped', 'bounced');

-- CreateEnum
CREATE TYPE "SubscriptionsDuration" AS ENUM ('monthly', 'quarterly', 'halfYealy', 'yearly');

-- CreateEnum
CREATE TYPE "LedgerType" AS ENUM ('bank', 'cash', 'purchase', 'sales', 'directExpense', 'indirectExpense', 'directIncome', 'indirectIncome', 'fixedAssets', 'currentAssets', 'loansAndLiabilities', 'accountsReceivable', 'accountsPayable');

-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('credit', 'debit');

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

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Otp" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "otp" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "used" BOOLEAN NOT NULL DEFAULT false,

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

    CONSTRAINT "BusinessProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Cart" (
    "id" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Cart_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ApiService" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "overview" TEXT NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "upcoming" BOOLEAN NOT NULL,
    "endpoint" JSONB,
    "bodyParams" JSONB,
    "response" JSONB,
    "responseJSON" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ApiService_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Subscriptions" (
    "id" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "amountForServices" DOUBLE PRECISION NOT NULL,
    "txnid" TEXT,
    "pid" TEXT,
    "subscriptionDuration" "SubscriptionsDuration" NOT NULL DEFAULT 'monthly',
    "status" "SubscriptionStatus" NOT NULL DEFAULT 'pending',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ledger" (
    "id" TEXT NOT NULL,
    "ledgerName" TEXT NOT NULL,
    "openingBalance" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "balance" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "userId" INTEGER NOT NULL,
    "partyId" TEXT,
    "year" INTEGER NOT NULL DEFAULT 2023,
    "month" INTEGER NOT NULL DEFAULT 0,
    "ledgerType" "LedgerType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Ledger_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "JournalEntry" (
    "id" TEXT NOT NULL,
    "entryDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "description" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "JournalEntry_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transaction" (
    "id" TEXT NOT NULL,
    "ledgerId" TEXT NOT NULL,
    "journalEntryId" TEXT NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "transactionType" "TransactionType" NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
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
    "serviceName" TEXT NOT NULL,
    "serviceType" TEXT,
    "imgUrl" TEXT,
    "description" TEXT,
    "price" DECIMAL(65,30) NOT NULL,
    "gst" DECIMAL(65,30) NOT NULL,
    "documents" JSONB NOT NULL,
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
    "orderId" INTEGER NOT NULL,

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
    "imageUrl" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Post_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account" (
    "id" TEXT NOT NULL,
    "accountName" TEXT NOT NULL,
    "totalDebit" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "totalCredit" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "debitBalance" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "creditBalance" DECIMAL(65,30) NOT NULL DEFAULT 0.0,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
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


INSERT INTO "User" (
  "id", "email", "password", "firstName", "gender"
) VALUES (
  4, 'akshatg9636@gmail.com', 'akshat@1234', 'Akshat', 'male'
);


--
-- Dumping data for table `RegisterStartup`
--

INSERT INTO "RegisterStartup" ("id", "title", "image", "userId", "categories", "aboutService", "priceWithGst") VALUES
(1, 'Title', 'https://res.cloudinary.com/dhqpgwpgq/image/upload/v1715231378/dashboard/users/mukulbedi%40yahoo.com/register/1/Screenshot%20%282009%29_1715231376834.png', 4, 'companyRegistration', NULL, NULL),
(2, 'PF Registration', '/images/PF-Registration.jpeg', 4, 'registration', 'PF Registration, short for Provident Fund Registration, is a mandatory process for organizations in India that employ a certain minimum number of employees, typically 20 or more. It is governed by the Employees Provident Fund and Miscellaneous Provisions Act, 1952, and overseen by the Employees Provident Fund Organization (EPFO), a statutory body under the Ministry of Labour and Employment, Government of India.\n\nUnder this scheme, both employees and employers make regular contributions from the employees basic salary and dearness allowance (DA) to create a retirement savings fund. This fund provides financial security to employees during their retirement years and offers various benefits, including lump-sum withdrawals, pension, and financial assistance in emergencies.\n\nThe PF Registration process is crucial for both employers and employees, ensuring compliance with government regulations and providing retirement benefits to the workforce. Employers are required to deposit contributions regularly and maintain accurate records of transactions. The EPFO has also introduced online services to simplify the registration and management of PF accounts.', 999),
(3, 'FSSAI (Food License)', '/images/fssai.png', 4, 'registration', 'The FSSAI (Food Safety and Standards Authority of India) License is a mandatory 
legal requirement for any business involved in the manufacture, storage, 
distribution, sale, or import/export of food products. Governed by the Food 
Safety and Standards Act, 2006, this license ensures that the food served to 
consumers meets safety and hygiene standards. There are three types of 
licenses based on turnover: Basic Registration (below ₹12 lakh), State License 
(₹12 lakh–₹20 crore), and Central License (above ₹20 crore or import/export). 
Having an FSSAI license boosts customer trust, allows access to wider markets, 
and ensures quality control. It’s also crucial for getting listed on food aggregator 
platforms like Swiggy or Zomato. Displaying the 14-digit FSSAI number on food 
packaging and premises is mandatory. Non-compliance can lead to penalties, 
product seizure, or even business closure. In short, the FSSAI license not only 
ensures legal operation but also supports branding, marketing, and business 
growth in the food sector.', 999),
(4, 'DSC (Digital Signature Certification)', '/images/dsc.jpeg', 4, 'registration', 'A Digital Signature Certificate (DSC) is an electronic form of a signature that 
authenticates the identity of the sender of a document. It is issued by Certifying 
Authorities (CAs) and is legally valid under the Information Technology Act, 2000. 
DSCs are essential for filing income tax returns, GST applications, MCA filings for 
companies, and participating in e-tenders. It ensures security and integrity in 
online transactions by encrypting documents and verifying authenticity. There 
are diAerent classes of DSC—Class 2 is used for company filings, and Class 3 is 
used for e-tenders and government bidding processes. Using a DSC prevents 
data tampering and establishes the signer’s identity digitally. It is a key 
requirement for professionals, companies, and vendors dealing with government 
departments or financial institutions. Without a DSC, many online processes 
cannot be completed. It helps streamline documentation, saves time, and builds 
trust in electronic communications. ', 999),
(5, 'Station8/NGO Registration', '/images/MSME.jpeg', 4, 'registration', 'NGO (Non-Governmental Organization) or Section 8 Company Registration is for 
individuals or groups aiming to work for charitable, religious, educational, or 
social causes. In India, NGOs can be registered as a Trust under the Indian Trusts 
Act, as a Society under the Societies Registration Act, or as a Section 8 Company 
under the Companies Act, 2013. Section 8 Companies have the advantage of 
legal recognition, credibility, and the ability to receive foreign funding under 
FCRA (Foreign Contribution Regulation Act). Registration allows NGOs to open a 
bank account, apply for government schemes, and get tax exemptions under 
sections 12A and 80G. It is crucial for transparency, fundraising, and building 
public trust. Without registration, its diAicult to operate formally or raise funds. It 
also helps create employment, promote awareness, and uplift underserved 
communities through structured, lawful activities', 999),
(6, 'Nidhi Company', '/logo.svg', 4, 'companyRegistration', 'A Nidhi Company is a type of Non-Banking Financial Company (NBFC) registered 
under Section 406 of the Companies Act, 2013. Its main objective is to promote 
the habit of savings and thrift among its members. Unlike traditional NBFCs, 
Nidhi Companies can only accept deposits and lend money to their members, 
making them ideal for small community-based savings groups. To register, at 
least seven members and a minimum paid-up capital of ₹10 lakh are required. 
The company must include “Nidhi Limited” in its name and follow specific RBI 
guidelines, although it does not require RBI approval to operate. Nidhi 
Companies oAer low-interest loans, encourage financial discipline, and provide 
safe investment opportunities within a group. Registration involves obtaining 
DSCs, DINs, name reservation, MOA/AOA filing, and incorporation via the MCA 
portal. This structure is suitable for people who want to run a mutual benefit 
society with legal recognition and regulatory clarity. Non-compliance can lead to 
license cancellation or penalties. ', 999),
(7, 'ESI Registration', '/images/ESIRegistration.jpeg', 4, 'registration', 'Employee State Insurance (ESI) Registration is mandatory for establishments 
with 10 or more employees earning ₹21,000 or less per month. Governed by the 
Employee State Insurance Corporation (ESIC) under the ESI Act, 1948, it provides 
medical, sickness, maternity, and disability benefits to employees. The employer 
contributes 3.25% and the employee contributes 0.75% of the wages towards 
ESI. Registered employers must file monthly returns and maintain compliance to 
avoid penalties. ESI coverage includes access to ESI hospitals, medical leave, 
and funeral expenses. For employers, it promotes goodwill and demonstrates 
compliance with labor laws. Failure to register can result in heavy fines and legal 
consequences. Registration not only protects employee welfare but also 
enhances the organizations reputation. ', 999),
(8, 'Partnership Registration', '/images/partners.png', 4, 'registration', 'Partnership Registration is the process of legally registering a business that is 
owned and managed by two or more individuals who agree to share profits and 
responsibilities. It is governed by the Indian Partnership Act, 1932. While 
registration is optional, it is highly recommended for legal recognition. A 
registered partnership firm can file cases against partners or third parties, open a 
business bank account, apply for loans, and participate in government tenders. 
The partnership deed outlines terms such as profit-sharing ratio, capital 
contribution, responsibilities, and exit terms of the partners. Registration is done 
with the Registrar of Firms by submitting documents like the deed, PAN, and 
ID/address proof. It ensures transparency among partners, avoids disputes, and 
brings credibility to the firm. Without registration, the partnership cannot enjoy 
legal benefits such as contract enforcement or settling disputes in court. It is a 
simple yet powerful way to structure a small to medium-sized business legally 
and eAiciently. ', 999),
(9, 'MSME Registration', '/images/MSME.jpeg', 4, 'registration', 'MSME (Micro, Small, and Medium Enterprises) Registration is a government 
initiative to support small-scale industries in India. It is now known as Udyam 
Registration and is governed by the Ministry of MSME. This registration is 
available to manufacturers and service providers whose turnover and investment 
fall under the defined limits. MSMEs benefit from schemes such as collateral
free loans, interest subsidies, reduced electricity bills, and protection against 
delayed payments. Registration also oAers eligibility for government tenders and 
preference in procurement policies. Udyam Registration can be completed 
online with basic details like Aadhaar, PAN, and business information. It also 
provides access to subsidies on patent registration, ISO certification, and market 
development. Although not mandatory, MSME registration is essential for 
startups and small businesses to grow with government support. It enhances the 
business’s competitiveness and opens the door to financial and technical 
assistance, making it an important step for sustainable growth.', 999),
(10, 'License Registration', '/logo.svg', 4, 'registration', 'License Registration refers to the process of obtaining legal permission from 
government authorities to operate a specific type of business. Depending on the nature 
of business—such as food, manufacturing, education, or finance—various licenses may 
be required like Trade License, Pollution Control License, FSSAI, or Drug License. 
Operating without the necessary license can lead to penalties, closure of business, or 
legal action. License Registration ensures that a business is compliant with regulatory 
requirements and adheres to industry standards. It builds consumer trust, facilitates 
smooth operations, and qualifies a business for government support and bank 
financing. Every business should verify its legal obligations and acquire the appropriate 
licenses before starting operations. This step ensures legitimacy, avoids future legal 
hassles, and improves credibility with customers, partners, and suppliers.', 999),
(11, 'ISO Registration', '/images/iso.png', 4, 'registration', 'ISO (International Organization for Standardization) Registration or Certification 
is a process through which a business demonstrates compliance with 
international standards in quality, safety, eAiciency, and service. The most 
popular ISO certifications include ISO 9001 (Quality Management), ISO 14001 
(Environmental Management), and ISO 27001 (Information Security 
Management). ISO certification is not mandatory, but it greatly improves 
customer trust and global recognition. It enhances operational performance, 
opens up international markets, and helps in securing government and corporate 
contracts. The registration process includes a gap analysis, documentation, 
implementation of standards, internal audits, and final certification by an 
accredited agency. It boosts your brand’s credibility and shows your 
commitment to continuous improvement and customer satisfaction. ISO 
Certification is essential for businesses aiming to scale, export, or improve 
operational eAiciency.', 999),
(12, 'Professional Tax Registration', '/images/professionalTax.jpeg', 4, 'registration', 'Professional Tax is a state-level tax levied on salaried employees and professionals like 
doctors, lawyers, and chartered accountants. Employers are responsible for deducting 
this tax from employee salaries and depositing it with the state government. The rates 
and regulations vary by state, with some like Maharashtra and Karnataka having strict 
rules and penalties for non-compliance. Professional Tax Registration is mandatory for 
employers within specified limits, and failure to register can result in fines and legal 
issues. The registration allows for legal payroll management and supports compliance 
with state labor laws. Once registered, businesses must file periodic returns. This tax is 
also required to be paid by individuals engaged in professions, trades, or employment. 
Registering on time helps avoid future penalties and ensures smooth operations in 
business payroll management.', 999),
(13, 'Ration Card', '/logo.svg', 4, 'registration', 'A Ration Card is an oAicial document issued by the state government that 
enables eligible households to purchase subsidized food grains and other 
essential commodities through the Public Distribution System (PDS). It serves as 
a key identity and residential proof, especially for those belonging to the 
economically weaker sections. There are diAerent types of ration cards: APL 
(Above Poverty Line), BPL (Below Poverty Line), and Antyodaya cards for the 
poorest. The card lists all family members and entitles them to food grains like 
rice, wheat, and sugar at lower prices. Apart from its use in obtaining rationed 
goods, it is also accepted for availing government schemes, school admissions, 
and opening bank accounts. The process of obtaining a ration card includes 
submitting identity, income, and address proof to the local food department. It 
plays a vital role in ensuring food security and supporting the welfare of low
income families in India.', 999),
(14, 'Trust Registration', '/images/MSME.jpeg', 4, 'registration', 'Trust Registration involves legally creating a trust for charitable, religious, or 
private purposes under the Indian Trusts Act, 1882 (for private trusts) or relevant 
state laws (for public trusts). A trust is formed when one party (the settlor) 
transfers property to another (the trustee) for the benefit of a third party (the 
beneficiary). For charitable trusts, the motive is public welfare, and they are 
often involved in education, healthcare, and relief eAorts. Registration provides 
the trust with legal recognition, helps in opening a bank account, applying for 
12A and 80G tax exemptions, and receiving donations. The process includes 
preparing a trust deed, notarizing it, and registering with the sub-registrar’s 
oAice. Registered trusts can also apply for FCRA approval to receive foreign 
donations. It enhances transparency, builds public trust, and allows access to 
government grants and donor support. Proper registration also ensures that the 
trust operates lawfully and protects its assets.', 999),
(15, 'Trademark Reply', '/logo.svg', 4, 'registration', 'Trademark Reply refers to the formal response submitted by an applicant when 
the Trademark Registry raises an objection against a trademark application. 
Objections usually arise due to similarity with an existing mark, lack of 
distinctiveness, or improper classification. The reply must be submitted within 
30 days from receiving the Examination Report. A well-drafted reply should 
include legal justifications, evidence of use (if applicable), and supporting 
documents like advertising material or product packaging. Filing a strong reply 
increases the chances of registration and helps avoid rejection or further 
litigation. If the reply is accepted, the application proceeds to publication in the 
Trademark Journal. If not, a hearing is scheduled. Timely and accurate response 
demonstrates seriousness and professionalism of the applicant, while failure to 
respond may lead to abandonment of the application. Professional help is often 
recommended in drafting replies to avoid common legal pitfalls.', 999),
(16, 'Fire License Registration', '/logo.svg', 4, 'registration', 'A Fire License (or Fire Safety Certificate) is an oAicial approval issued by the Fire 
Department certifying that a building or business premises complies with the fire 
safety norms prescribed by law. It is mandatory for establishments like schools, 
hospitals, restaurants, shopping malls, warehouses, and other commercial 
complexes. The objective is to ensure public safety, prevent fire hazards, and 
enable safe evacuation during emergencies. The license is issued after a 
thorough inspection of fire safety installations like extinguishers, alarms, 
sprinkler systems, emergency exits, and evacuation plans. Obtaining a fire 
license is essential for acquiring other business permits and for insurance 
claims in case of accidents. Operating without a fire license can lead to 
penalties, business closure, or criminal charges. It’s not just a legal necessity, 
but also a critical step toward building a secure and trusted business 
environment for employees and customers alike. ', 999),
(17, 'IE License Partnership', '/images/MSME.jpeg', 4, 'registration', 'An Import Export Code (IEC) is a 10-digit unique identification number issued by 
the Directorate General of Foreign Trade (DGFT), Ministry of Commerce, 
Government of India. It is mandatory for any individual or business involved in 
importing or exporting goods or services from India. IEC is a one-time registration 
with lifetime validity and is essential for customs clearance, shipping, receiving 
foreign currency, and availing benefits from Export Promotion Councils or 
government schemes like MEIS and SEIS. The application is filed online with 
basic KYC documents, a PAN card, and bank details. Without IEC, international 
trade operations are illegal. It also helps establish a business as a global entity 
and expands its credibility in foreign markets. IEC is not required for personal use 
imports and exports. Having an active IEC not only opens up international 
opportunities but also simplifies regulatory procedures in global commerce.', 999),
(18, 'Trade Mark Renewal', '/images/tradeMarkRenewal.png', 4, 'registration', 'Trademark Renewal is the process of extending the legal protection of a 
registered trademark beyond its initial validity period of 10 years. In India, 
trademarks can be renewed indefinitely every 10 years by filing a renewal 
application with the Trademark Registry. The renewal must be applied for within 
six months before the expiry date to avoid penalties. Failing to renew the 
trademark on time may result in removal from the registry, leading to loss of 
exclusive rights and potential brand misuse. The process involves filing Form TM
R along with the prescribed fee. Renewal maintains the owner’s legal rights to 
use the mark and take action against infringement. It also protects brand 
reputation and market identity. Renewed trademarks continue to provide 
licensing and franchising opportunities, contributing to business expansion. ', 999),
(19, 'Shop Act Registration', '/logo.svg', 4, 'registration', 'Shop Act Registration, also known as the Shops and Establishments License, is a 
mandatory registration under the respective state’s Shops and Establishments 
Act. It is required for all commercial establishments such as shops, oAices, 
restaurants, and service centers. The objective is to regulate working conditions, 
employee rights, and operational guidelines like working hours, holidays, wages, 
and child labor. Registration must be done within 30 days of starting the 
business. The process is state-specific and usually completed online by 
submitting proof of identity, address, and establishment. This license is often 
required for opening a business bank account, applying for GST, and 
participating in government tenders.', 999),
(20, 'News Paper Registration', '/logo.svg', 4, 'registration', 'Newspaper Registration in India is governed by the Press and Registration of 
Books Act, 1867, and is managed by the Registrar of Newspapers for India (RNI). 
Any individual or organization planning to start a newspaper, magazine, journal, 
or periodical must register with the RNI. The process involves verifying the title, 
submitting ownership details, and providing a declaration by the publisher before 
a magistrate. Once approved, the publication is granted a unique RNI number. 
This registration is mandatory for postal privileges, government advertising, and 
press accreditation. It ensures that the publication is legally recognized and 
helps maintain accountability in media operations. Operating without RNI 
registration may result in rejection from government advertising panels and 
denial of postal benefits. It also protects the publication’s name from being used 
by others. RNI registration boosts credibility and is essential for transparency in 
news publishing.', 999),
(21, 'PF Monthly Return', '/logo.svg', 4, 'returns', 'PF Monthly Return is the monthly report filed by employers with the Employees’ 
Provident Fund Organization (EPFO) detailing employee contributions toward 
Provident Fund accounts. It includes information such as Universal Account 
Numbers (UAN), employee wages, employer and employee contributions, and 
other compliance details. Filing is done online through the EPFO portal using 
Electronic Challan cum Return (ECR). It must be submitted by the 15th of every 
month for the previous month’s payroll cycle. This return ensures timely credit of 
PF amounts into employees’ accounts and keeps the business in compliance 
with labor laws. Non-filing or delayed submission can result in penalties, 
interest, and loss of employee benefits. Monthly returns reflect the company’s 
discipline in social security commitments and help employees access benefits 
such as loans, withdrawals, or pensions.', 999),
(22, 'Registered Office Change', '/logo.svg', 4, 'companyRegistration', 'Changing a company Registered OAice refers to updating the oAicial address 
with the Ministry of Corporate AAairs (MCA). This is important as all oAicial 
correspondence, legal notices, and government communication are sent to the 
registered oAice. The type of procedure varies based on whether the move is 
within the same city, from one city to another in the same state, or from one state 
to another. The process includes board resolution, shareholder approval, filing of 
relevant forms like INC-22 or MGT-14, and sometimes approval from the Regional 
Director (in case of interstate shift). Supporting documents such as utility bills, 
rent agreement, or NOC from the property owner are required. Timely updating 
ensures smooth operation, avoids legal complications, and ensures compliance. 
Failure to notify a registered oAice change can result in fines or disqualification 
of directors. This change is vital when companies expand, relocate, or 
restructure their operations.', 999),
(23, 'Corporation License', '/logo.svg', 4, 'companyRegistration', 'A Corporation License, often referred to as a Trade License, is issued by the 
municipal corporation of a city or town. It grants legal permission to carry out 
specific commercial activities within that jurisdiction. It is applicable to 
businesses like shops, oAices, factories, restaurants, and other establishments. 
The objective is to regulate business practices, ensure compliance with local 
laws, and safeguard public health and safety. The license must be obtained 
before the commencement of business and is usually valid for one financial year, 
renewable annually. The process includes submitting identity proof, address 
proof, NOC from the property owner, and business details to the municipal 
authority. Operating without a Corporation License can lead to fines, closure of 
the business, or legal action. Having this license improves the business’s 
credibility and makes it easier to acquire other necessary registrations like GST, 
MSME, or FSSAI. ', 999),
(24, 'Company Registration', '/logo.svg', 4, 'companyRegistration', 'Company Registration is the legal process of incorporating a new business entity 
under the Companies Act, 2013 in India. It is governed by the Ministry of 
Corporate AAairs (MCA). A company can be registered as a Private Limited 
Company, Public Limited Company, One Person Company (OPC), or Section 8 
Company, depending on its nature and objectives. The process includes 
choosing a unique name, obtaining DSCs (Digital Signature Certificates) and 
DINs (Director Identification Numbers), drafting the Memorandum and Articles 
of Association, and filing incorporation documents with the MCA. Once 
registered, the company receives a Certificate of Incorporation and a unique 
Corporate Identity Number (CIN). Benefits of company registration include 
limited liability, brand recognition, investor credibility, legal protection, and 
eligibility for bank loans and tenders. ', 999),
(25, 'Copy Right Registration', '/images/copyrightRegistration.png', 4, 'registration', 'Copyright Registration grants legal protection to original works of authorship 
such as literature, music, art, software, photography, and films. Under the 
Copyright Act, 1957, registration gives the creator exclusive rights to reproduce, 
distribute, perform, or license the work. While copyright exists automatically 
once a work is created, registration serves as legal proof of ownership and is 
essential in case of disputes or infringement. The process involves submitting an 
online application, paying the fee, and undergoing a scrutiny period. Once 
approved, the Copyright OAice issues a registration certificate. The copyright 
lasts for the author’s lifetime plus 60 years after their death. Registered copyright 
can be sold, assigned, or licensed, adding commercial value to creative work. It 
is especially important for digital creators, authors, filmmakers, musicians, and 
software developers. Without registration, proving authorship in court can be 
diAicult. It also enables creators to enforce their rights and prevent unauthorized 
use of their content. ', 999),
(26, 'OPC Registration', '/logo.svg', 4, 'companyRegistration', 'OPC (One Person Company) Registration is designed for solo entrepreneurs who 
wish to operate a corporate structure without partners. Introduced under the 
Companies Act, 2013, OPC allows a single individual to incorporate a company 
with limited liability and full control over operations. It combines the advantages 
of sole proprietorship and private limited companies. To register an OPC, one 
must be an Indian citizen and resident. The registration involves obtaining a DSC 
and DIN, choosing a name, and submitting MOA, AOA, and nominee details on 
the MCA portal. The nominee is mandatory in case of the owners death or 
incapacity. OPCs enjoy easier compliance, exemption from annual general 
meetings, and limited liability, making them ideal for small-scale businesses, 
consultants, and professionals.', 999),
(27, 'Association Formation', '/logo.svg', 4, 'registration', 'Association Formation refers to legally establishing a group of individuals united 
by a common objective—social, cultural, educational, or charitable. In India, 
associations can be registered as Societies under the Societies Registration Act, 
1860. The registration provides legal identity to the group, allowing it to own 
property, enter contracts, and operate a bank account. It also helps in receiving 
government grants, donations, and foreign funding. The formation process 
includes drafting a Memorandum of Association, defining objectives, rules, and 
the management structure, followed by submitting documents to the Registrar of 
Societies. Registered associations are required to maintain records and submit 
annual reports. Registration adds credibility, transparency, and organizational 
structure, making it easier to attract members and funding. It also protects the 
association’s name and ensures legal rights in court. Unregistered associations, 
on the other hand, lack legal status and face restrictions in fundraising and 
operations.', 999),
(28, 'Copyright Reply', '/logo.svg', 4, 'registration', 'A Copyright Reply is a formal response submitted by the applicant when the 
Copyright OAice raises objections or discrepancies regarding a copyright 
registration application. Objections may arise due to incomplete 
documentation, similarity with existing work, improper classification, or doubts 
about originality. The reply should clarify the issue with supporting evidence 
such as proof of authorship, publication records, or creative process 
documentation. A strong and well-drafted reply can prevent rejection and ensure 
registration of the work. The reply must be submitted within the specified 
timeline to avoid abandonment of the application. It helps protect the creator’s 
intellectual property by clarifying their legal right to the work. Professional help is 
often advised, as a technical or vague response can lead to delays or denials. 
Filing a copyright reply is a critical step in securing creative ownership and 
enabling future enforcement of legal rights in case of infringement.', 999),
(29, 'TDS Return Filing', '/logo.svg', 4, 'returns', 'TDS (Tax Deducted at Source) Return Filing is the quarterly submission of details 
regarding tax deducted by a business or individual on payments such as salaries, 
rent, professional fees, and interest. It is mandatory under the Income Tax Act for 
all entities with a valid TAN (Tax Deduction and Collection Account Number). TDS 
returns are filed using Forms 24Q (salaries), 26Q (non-salaries), 27Q (foreign 
payments), and 27EQ (TCS). The returns include PAN of deductees, amounts 
paid, TDS deducted and deposited. Timely filing ensures credit of TDS in the 
recipients 26AS form and avoids penalties. Failure to file or late filing attracts 
penalties of ₹200 per day and interest on delayed deposits. Filing TDS returns 
maintains transparency, fulfills legal obligations, and ensures smooth 
processing of income tax returns for both payers and payees. ', 999),
(30, 'GST Registration', '/images/gst.jpeg', 4, 'registration', 'GST (Goods and Services Tax) Registration is mandatory for businesses whose 
annual turnover exceeds the threshold limit (₹20 lakh for service providers and 
₹40 lakh for goods suppliers in most states). It is governed by the Central Board 
of Indirect Taxes and Customs (CBIC) and helps consolidate multiple indirect 
taxes into a single tax structure. GST registration allows businesses to legally 
collect tax from customers and claim input tax credits on purchases. It is also 
compulsory for e-commerce sellers, exporters, importers, and inter-state 
suppliers. The process is conducted online via the GST portal and requires PAN, 
address proof, business details, and bank account information. Once registered, 
the business receives a unique GSTIN (Goods and Services Tax Identification 
Number). Failure to register may result in penalties, tax evasion charges, or 
business closure. Registered businesses can file GST returns, issue tax invoices, 
and enjoy streamlined tax compliance.', 999),
(31, 'TAN Registration', '/logo.svg', 4, 'companyRegistration', 'TAN (Tax Deduction and Collection Account Number) Registration is mandatory 
for businesses and individuals who are responsible for deducting or collecting 
tax at source (TDS/TCS) under the Income Tax Act, 1961. It is a 10-digit 
alphanumeric number issued by the Income Tax Department. TAN must be 
quoted in all TDS/TCS returns, challans, and certificates. Failure to apply for TAN 
or quoting the wrong TAN can lead to penalties. The registration process is online 
and requires submitting Form 49B with details like name, address, and PAN of 
the entity. Once obtained, it enables the filer to deduct tax from payments such 
as salaries, rent, commissions, and professional fees. Timely TAN registration is 
essential for regulatory compliance, smooth processing of refunds, and avoiding 
legal complications.', 999),
(32, 'Advertisement Agency', '/logo.svg', 4, 'registration', 'Advertisement Agency Registration is required for starting a legal advertising 
business oAering services like marketing, promotions, media buying, branding, 
and digital ads. Although there is no specific central license, agencies must 
register under appropriate legal forms such as sole proprietorship, partnership, 
LLP, or private limited company. Additional registrations may include GST, Shop 
Act, and Professional Tax depending on state rules. If the agency handles 
government ads, it must also register with the Directorate of Advertising and 
Visual Publicity (DAVP) or similar state-level departments. Proper registration 
enables legal contracts, billing, and participation in tenders or media buying 
networks. It builds trust with clients, suppliers, and partners. An unregistered 
agency may face legal consequences, lack access to industry tools, or lose 
client opportunities.', 999),
(33, 'Audit 44AD', '/logo.svg', 4, 'audits', 'Section 44ADA of the Income Tax Act provides a presumptive taxation scheme 
for professionals like doctors, lawyers, architects, engineers, and consultants 
with gross receipts up to ₹50 lakh. Under this section, 50% of the gross receipts 
are deemed as income, and no detailed accounting is required. This simplifies 
tax filing and reduces the burden of bookkeeping. However, if the professional 
chooses to declare income lower than 50% and their total income exceeds the 
exemption limit, a tax audit under Section 44AB becomes mandatory. This 
section promotes compliance among small and independent professionals by 
oAering a simplified method of income calculation. It is especially beneficial for 
freelancers, solo practitioners, and consultants. Taxpayers opting for 44ADA also 
get relief from maintaining books of accounts under Section 44AA. Audit under 
44ADA is necessary only if the presumptive scheme is not followed or income is 
understated.', 999),
(34, 'LLP Registration', '/logo.svg', 4, 'companyRegistration', 'LLP (Limited Liability Partnership) Registration is a process of incorporating a 
business under the Limited Liability Partnership Act, 2008. It combines the 
benefits of a partnership firm and a company. LLPs oAer flexibility in 
management like partnerships but limit the personal liability of partners to their 
capital contribution. This makes it a popular choice among startups, 
consultants, and service-based firms. To register an LLP, at least two partners 
are required, with one being an Indian resident. The process includes obtaining 
DSCs, reserving a name, filing incorporation documents, and drafting an LLP 
Agreement. Once registered, the LLP receives a Certificate of Incorporation 
along with a PAN and TAN. LLPs enjoy minimal compliance requirements, no 
mandatory audits (unless turnover exceeds limits), and tax benefits.', 999),
(35, 'Share Allotment', '/logo.svg', 4, 'companyRegistration', 'Share Allotment is the process by which a company distributes shares to its 
shareholders or investors after the company’s incorporation or during 
fundraising rounds. This step is essential to legally record ownership and 
investment in the company. Allotment can be done during initial subscriptions, 
rights issues, or private placements. After allotment, the company must file 
Form PAS-3 with the Ministry of Corporate AAairs (MCA) and update the share 
register. It involves issuing share certificates, maintaining a Register of Members, 
and recording all transactions in the minutes of the board meeting. Allotment 
provides legal ownership rights like voting, dividends, and transferability of 
shares. It also helps in raising capital for business expansion and increasing 
credibility among stakeholders. ', 999),
(36, 'ESI Monthly Return', '/logo.svg', 4, 'returns', 'ESI (Employee State Insurance) Monthly Return is the report submitted by 
employers to the ESIC (Employees State Insurance Corporation) detailing 
contributions made on behalf of employees. It includes the names of insured 
employees, wages paid, and contributions (employer 3.25%, employee 0.75%). 
Returns are filed monthly via the ESIC portal, typically by the 15th of each month 
for the previous period. This ensures employees receive medical, maternity, and 
other benefits in a timely manner. Filing ESI returns helps the ESIC maintain 
accurate employee benefit records and facilitates quick access to services in 
emergencies. Non-filing or incorrect reporting can attract fines, interest, or 
cancellation of registration. Regular and correct filing supports employee welfare  
and enhances organizational compliance. ', 999),
(37, 'GST Return', '/logo.svg', 4, 'returns', 'GST Return is a document filed by registered taxpayers under the Goods and 
Services Tax regime to report their sales, purchases, tax collected, and tax paid. 
These returns are used by tax authorities to calculate net tax liability. Common 
forms include GSTR-1 (outward supplies), GSTR-3B (summary return), GSTR-9 
(annual return), and others depending on business activity. Filing is mandatory 
monthly or quarterly, and missing deadlines can lead to penalties and interest. 
GST return filing allows businesses to claim Input Tax Credit (ITC) and ensures 
transparency in taxation. Returns must be filed even if there is no business 
activity (NIL return). The process is fully online via the GST portal. Accurate return 
filing improves business credibility, enables participation in tenders, and ensures 
smooth functioning of the supply chain.', 999),
(38, 'Audit 44AE', '/logo.svg', 4, 'audits', 'Audit under Section 44AE of the Income Tax Act is designed for taxpayers 
engaged in the business of plying, hiring, or leasing goods carriages. This 
presumptive taxation scheme is applicable to individuals, HUFs, firms (excluding 
LLPs) owning no more than 10 goods vehicles during the year. Under this 
scheme, income is deemed at ₹1,000 per ton of gross vehicle weight for heavy 
vehicles and ₹7,500 per month per vehicle for others. This removes the need to 
maintain detailed books or undergo a regular tax audit. However, if the taxpayer 
wants to declare income less than the presumed income and total income 
exceeds the taxable limit, then an audit is mandatory under Section 44AB. This 
scheme simplifies tax compliance for transport businesses and reduces 
administrative overhead. It is important for taxpayers to file returns within due 
dates and maintain basic records to avoid penalties and legal issues.', 999),
(39, 'Accounting', '/images/accounting.webp', 4, 'audits', 'Accounting refers to the systematic recording, reporting, and analysis of 
financial transactions of a business. It includes bookkeeping, preparation of 
financial statements, tax filing, payroll management, and budget planning. 
Proper accounting ensures legal compliance, helps businesses track income 
and expenses, manage cash flow, and assess profitability. It is essential for filing 
GST, income tax returns, and audits. Accounting practices can be manual or 
software-based (e.g., Tally, Zoho Books, QuickBooks). Small businesses may 
outsource this to professionals or accounting firms, while larger entities usually 
have internal departments. Accurate accounting also helps during investor 
pitching, loan applications, and government tenders. It forms the backbone of 
sound business management and financial health. Regular accounting prevents 
errors, fraud, and tax defaults.', 999),
(40, 'Audit 44ADA', '/logo.svg', 4, 'audits', 'Audit under Section 44AD of the Income Tax Act applies to small businesses 
opting for the presumptive taxation scheme. This section allows eligible 
businesses with turnover up to ₹2 crore to declare profits at a presumptive rate 
of 8% (or 6% for digital transactions) without maintaining detailed books of 
accounts. If the taxpayer declares income lower than the prescribed rate and 
their total income exceeds the basic exemption limit, they must get their 
accounts audited under Section 44AB. The purpose of 44AD is to reduce 
compliance burden and encourage digital transactions for small businesses. 
Businesses such as retail shops, traders, or contractors can benefit from this 
section. However, if a person opts out of 44AD after choosing it, they cannot opt 
in again for the next 5 years. Audit under 44AD is mandatory only when the 
taxpayer fails to follow the presumptive rules and declares lesser income. ', 999);

-- --------------------------------------------------------


    


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
CREATE TABLE "_ApiServiceToCart" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_ApiServiceToSubscriptions" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_AccountToInvoice" (
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
CREATE UNIQUE INDEX "Agent_userId_key" ON "Agent"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "RegisterServices_serviceId_key" ON "RegisterServices"("serviceId");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_5A_sr_no_key" ON "Gstr1_5A"("sr_no");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_6A_sr_no_key" ON "Gstr1_6A"("sr_no");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_7B_sr_no_key" ON "Gstr1_7B"("sr_no");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_8ABCD_sr_no_key" ON "Gstr1_8ABCD"("sr_no");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_9B_sr_no_key" ON "Gstr1_9B"("sr_no");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_9B_un_sr_no_key" ON "Gstr1_9B_un"("sr_no");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_11A2A2_sr_no_key" ON "Gstr1_11A2A2"("sr_no");

-- CreateIndex
CREATE UNIQUE INDEX "Gstr1_11B1B2_sr_no_key" ON "Gstr1_11B1B2"("sr_no");

-- CreateIndex
CREATE UNIQUE INDEX "gstr1_12HSN_sr_no_key" ON "gstr1_12HSN"("sr_no");

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
CREATE UNIQUE INDEX "_ApiServiceToCart_AB_unique" ON "_ApiServiceToCart"("A", "B");

-- CreateIndex
CREATE INDEX "_ApiServiceToCart_B_index" ON "_ApiServiceToCart"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_ApiServiceToSubscriptions_AB_unique" ON "_ApiServiceToSubscriptions"("A", "B");

-- CreateIndex
CREATE INDEX "_ApiServiceToSubscriptions_B_index" ON "_ApiServiceToSubscriptions"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_AccountToInvoice_AB_unique" ON "_AccountToInvoice"("A", "B");

-- CreateIndex
CREATE INDEX "_AccountToInvoice_B_index" ON "_AccountToInvoice"("B");

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
ALTER TABLE "Ledger" ADD CONSTRAINT "Ledger_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ledger" ADD CONSTRAINT "Ledger_partyId_fkey" FOREIGN KEY ("partyId") REFERENCES "Party"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JournalEntry" ADD CONSTRAINT "JournalEntry_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_ledgerId_fkey" FOREIGN KEY ("ledgerId") REFERENCES "Ledger"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_journalEntryId_fkey" FOREIGN KEY ("journalEntryId") REFERENCES "JournalEntry"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

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
ALTER TABLE "Invoice" ADD CONSTRAINT "Invoice_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Invoice" ADD CONSTRAINT "Invoice_partyId_fkey" FOREIGN KEY ("partyId") REFERENCES "Party"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InvoiceItem" ADD CONSTRAINT "InvoiceItem_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES "Item"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InvoiceItem" ADD CONSTRAINT "InvoiceItem_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "Invoice"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UploadedDocument" ADD CONSTRAINT "UploadedDocument_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UploadedDocument" ADD CONSTRAINT "UploadedDocument_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "LoanApplication"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LoanApplication" ADD CONSTRAINT "LoanApplication_loanId_fkey" FOREIGN KEY ("loanId") REFERENCES "Loan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LoanApplication" ADD CONSTRAINT "LoanApplication_bankAccountId_fkey" FOREIGN KEY ("bankAccountId") REFERENCES "BankDetails"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LoanApplication" ADD CONSTRAINT "LoanApplication_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LoanApplication" ADD CONSTRAINT "LoanApplication_agentId_fkey" FOREIGN KEY ("agentId") REFERENCES "Agent"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BankDetails" ADD CONSTRAINT "BankDetails_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Insurance" ADD CONSTRAINT "Insurance_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Client" ADD CONSTRAINT "Client_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Client" ADD CONSTRAINT "Client_agentId_fkey" FOREIGN KEY ("agentId") REFERENCES "Agent"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

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
ALTER TABLE "_ApiServiceToCart" ADD CONSTRAINT "_ApiServiceToCart_A_fkey" FOREIGN KEY ("A") REFERENCES "ApiService"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ApiServiceToCart" ADD CONSTRAINT "_ApiServiceToCart_B_fkey" FOREIGN KEY ("B") REFERENCES "Cart"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ApiServiceToSubscriptions" ADD CONSTRAINT "_ApiServiceToSubscriptions_A_fkey" FOREIGN KEY ("A") REFERENCES "ApiService"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ApiServiceToSubscriptions" ADD CONSTRAINT "_ApiServiceToSubscriptions_B_fkey" FOREIGN KEY ("B") REFERENCES "Subscriptions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_AccountToInvoice" ADD CONSTRAINT "_AccountToInvoice_A_fkey" FOREIGN KEY ("A") REFERENCES "Account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_AccountToInvoice" ADD CONSTRAINT "_AccountToInvoice_B_fkey" FOREIGN KEY ("B") REFERENCES "Invoice"("id") ON DELETE CASCADE ON UPDATE CASCADE;

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
