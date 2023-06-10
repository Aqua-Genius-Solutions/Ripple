/*
  Warnings:

  - Added the required column `Image` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "User" ADD COLUMN     "Image" TEXT NOT NULL,
ADD COLUMN     "NormalConsp" INTEGER;
