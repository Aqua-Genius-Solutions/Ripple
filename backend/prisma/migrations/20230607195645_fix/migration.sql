/*
  Warnings:

  - You are about to drop the column `CVC` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `NbFamMem` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `NormalConsp` on the `User` table. All the data in the column will be lost.
  - Added the required column `Image` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "User" DROP COLUMN "CVC",
DROP COLUMN "NbFamMem",
DROP COLUMN "NormalConsp",
ADD COLUMN     "Image" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "Bill" (
    "id" SERIAL NOT NULL,
    "price" INTEGER NOT NULL,
    "NFM" INTEGER NOT NULL,
    "consumption" INTEGER NOT NULL,
    "NormalConsp" INTEGER NOT NULL,
    "paid" BOOLEAN NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "Bill_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Bill" ADD CONSTRAINT "Bill_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("uid") ON DELETE RESTRICT ON UPDATE CASCADE;
