-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "surname" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "isPro" BOOLEAN NOT NULL,
    "creditCard" BIGINT NOT NULL,
    "CVC" INTEGER NOT NULL,
    "Referrals" INTEGER[],
    "Bubbles" BIGINT NOT NULL,
    "Reference" INTEGER NOT NULL,
    "isAdmin" BOOLEAN NOT NULL,
    "NbFamMem" INTEGER NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Events" (
    "id" SERIAL NOT NULL,
    "author" TEXT NOT NULL,
    "link" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "participants" INTEGER[],
    "image" TEXT NOT NULL,

    CONSTRAINT "Events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "News" (
    "id" SERIAL NOT NULL,
    "author" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "link" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "image" TEXT NOT NULL,

    CONSTRAINT "News_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Rewards" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "price" INTEGER NOT NULL,
    "image" INTEGER NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "Rewards_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_UserLikedEvents" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_UserLikedNews" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_UserLikedEvents_AB_unique" ON "_UserLikedEvents"("A", "B");

-- CreateIndex
CREATE INDEX "_UserLikedEvents_B_index" ON "_UserLikedEvents"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_UserLikedNews_AB_unique" ON "_UserLikedNews"("A", "B");

-- CreateIndex
CREATE INDEX "_UserLikedNews_B_index" ON "_UserLikedNews"("B");

-- AddForeignKey
ALTER TABLE "_UserLikedEvents" ADD CONSTRAINT "_UserLikedEvents_A_fkey" FOREIGN KEY ("A") REFERENCES "Events"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserLikedEvents" ADD CONSTRAINT "_UserLikedEvents_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserLikedNews" ADD CONSTRAINT "_UserLikedNews_A_fkey" FOREIGN KEY ("A") REFERENCES "News"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserLikedNews" ADD CONSTRAINT "_UserLikedNews_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
