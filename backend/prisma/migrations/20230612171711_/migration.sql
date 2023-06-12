/*
  Warnings:

  - You are about to drop the column `author` on the `Events` table. All the data in the column will be lost.
  - You are about to drop the column `participants` on the `Events` table. All the data in the column will be lost.
  - You are about to drop the column `CVC` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `NbFamMem` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `Reference` on the `User` table. All the data in the column will be lost.
  - Added the required column `balance` to the `CreditCard` table without a default value. This is not possible if the table is not empty.
  - Added the required column `title` to the `Events` table without a default value. This is not possible if the table is not empty.
  - Added the required column `Image` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `NFM` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `NormalConsp` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "CreditCard" ADD COLUMN     "balance" INTEGER NOT NULL,
ALTER COLUMN "number" SET DATA TYPE VARCHAR(16);

-- AlterTable
ALTER TABLE "Events" DROP COLUMN "author",
DROP COLUMN "participants",
ADD COLUMN     "title" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "User" DROP COLUMN "CVC",
DROP COLUMN "NbFamMem",
DROP COLUMN "Reference",
ADD COLUMN     "Image" TEXT NOT NULL,
ADD COLUMN     "NFM" INTEGER NOT NULL,
ADD COLUMN     "NormalConsp" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "Comment" (
    "id" SERIAL NOT NULL,
    "content" TEXT NOT NULL,
    "author" TEXT NOT NULL,
    "newsId" INTEGER NOT NULL,

    CONSTRAINT "Comment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bill" (
    "id" SERIAL NOT NULL,
    "price" DECIMAL(65,30) NOT NULL,
    "consumption" INTEGER NOT NULL,
    "paid" BOOLEAN NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "userId" TEXT NOT NULL,
    "imageUrl" TEXT NOT NULL,

    CONSTRAINT "Bill_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_UserParticipatedEvents" (
    "A" INTEGER NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_UserParticipatedEvents_AB_unique" ON "_UserParticipatedEvents"("A", "B");

-- CreateIndex
CREATE INDEX "_UserParticipatedEvents_B_index" ON "_UserParticipatedEvents"("B");

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_newsId_fkey" FOREIGN KEY ("newsId") REFERENCES "News"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bill" ADD CONSTRAINT "Bill_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("uid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserParticipatedEvents" ADD CONSTRAINT "_UserParticipatedEvents_A_fkey" FOREIGN KEY ("A") REFERENCES "Events"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserParticipatedEvents" ADD CONSTRAINT "_UserParticipatedEvents_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("uid") ON DELETE CASCADE ON UPDATE CASCADE;
