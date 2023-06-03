/*
  Warnings:

  - You are about to alter the column `creditCard` on the `User` table. The data in that column could be lost. The data in that column will be cast from `BigInt` to `Integer`.
  - You are about to alter the column `Bubbles` on the `User` table. The data in that column could be lost. The data in that column will be cast from `BigInt` to `Integer`.

*/
-- AlterTable
ALTER TABLE "User" ALTER COLUMN "creditCard" SET DATA TYPE INTEGER,
ALTER COLUMN "Bubbles" SET DATA TYPE INTEGER;
