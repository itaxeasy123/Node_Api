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
