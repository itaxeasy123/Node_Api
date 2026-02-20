-- CreateTable
CREATE TABLE "StatusWiseIncomeTaxCode" (
    "id" SERIAL NOT NULL,
    "code" TEXT NOT NULL,
    "status" TEXT NOT NULL,

    CONSTRAINT "StatusWiseIncomeTaxCode_pkey" PRIMARY KEY ("id")
);
