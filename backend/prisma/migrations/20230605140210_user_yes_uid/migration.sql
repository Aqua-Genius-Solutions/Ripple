/*
  Warnings:

  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `id` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `password` on the `User` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "_UserLikedEvents" DROP CONSTRAINT "_UserLikedEvents_B_fkey";

-- DropForeignKey
ALTER TABLE "_UserLikedNews" DROP CONSTRAINT "_UserLikedNews_B_fkey";

-- AlterTable
ALTER TABLE "User" DROP CONSTRAINT "User_pkey",
DROP COLUMN "id",
DROP COLUMN "password",
ADD COLUMN     "uid" SERIAL NOT NULL,
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("uid");

-- AddForeignKey
ALTER TABLE "_UserLikedEvents" ADD CONSTRAINT "_UserLikedEvents_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("uid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserLikedNews" ADD CONSTRAINT "_UserLikedNews_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("uid") ON DELETE CASCADE ON UPDATE CASCADE;
