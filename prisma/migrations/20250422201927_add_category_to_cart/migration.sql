/*
  Warnings:

  - You are about to drop the column `category` on the `ApiService` table. All the data in the column will be lost.
  - You are about to drop the `_ApiServiceToCart` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "_ApiServiceToCart" DROP CONSTRAINT "_ApiServiceToCart_A_fkey";

-- DropForeignKey
ALTER TABLE "_ApiServiceToCart" DROP CONSTRAINT "_ApiServiceToCart_B_fkey";

-- AlterTable
ALTER TABLE "ApiService" DROP COLUMN "category";

-- AlterTable
ALTER TABLE "Cart" ADD COLUMN     "category" TEXT;

-- DropTable
DROP TABLE "_ApiServiceToCart";

-- CreateTable
CREATE TABLE "_CartServices" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_CartServices_AB_unique" ON "_CartServices"("A", "B");

-- CreateIndex
CREATE INDEX "_CartServices_B_index" ON "_CartServices"("B");

-- AddForeignKey
ALTER TABLE "_CartServices" ADD CONSTRAINT "_CartServices_A_fkey" FOREIGN KEY ("A") REFERENCES "ApiService"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CartServices" ADD CONSTRAINT "_CartServices_B_fkey" FOREIGN KEY ("B") REFERENCES "Cart"("id") ON DELETE CASCADE ON UPDATE CASCADE;
