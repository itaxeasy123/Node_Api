/*
  Warnings:

  - Added the required column `deletedate` to the `Otp` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Otp" ADD COLUMN     "deletedate" TIMESTAMP(3) NOT NULL;
