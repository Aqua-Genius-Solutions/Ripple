/*
  Warnings:

  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.

*/
-- DropForeignKey
ALTER TABLE "_UserLikedEvents" DROP CONSTRAINT "_UserLikedEvents_B_fkey";

-- DropForeignKey
ALTER TABLE "_UserLikedNews" DROP CONSTRAINT "_UserLikedNews_B_fkey";

-- AlterTable
ALTER TABLE "User" DROP CONSTRAINT "User_pkey",
ALTER COLUMN "uid" SET DEFAULT '0',
ALTER COLUMN "uid" DROP DEFAULT,
ALTER COLUMN "uid" SET DATA TYPE TEXT,
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("uid");
DROP SEQUENCE "User_uid_seq";

-- AlterTable
ALTER TABLE "_UserLikedEvents" ALTER COLUMN "B" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "_UserLikedNews" ALTER COLUMN "B" SET DATA TYPE TEXT;

-- AddForeignKey
ALTER TABLE "_UserLikedEvents" ADD CONSTRAINT "_UserLikedEvents_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("uid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserLikedNews" ADD CONSTRAINT "_UserLikedNews_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("uid") ON DELETE CASCADE ON UPDATE CASCADE;
