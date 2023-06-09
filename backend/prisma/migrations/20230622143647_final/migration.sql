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
CREATE TABLE "CreditCard" (
    "id" SERIAL NOT NULL,
    "number" VARCHAR(16) NOT NULL,
    "CVC" INTEGER NOT NULL,
    "expDate" TIMESTAMP(3) NOT NULL,
    "ownerId" TEXT NOT NULL,
    "balance" INTEGER NOT NULL,

    CONSTRAINT "CreditCard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Events" (
    "id" SERIAL NOT NULL,
    "link" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "image" TEXT NOT NULL,
    "title" TEXT NOT NULL,

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
    "image" TEXT NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "Rewards_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "name" TEXT NOT NULL,
    "surname" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "isPro" BOOLEAN NOT NULL,
    "Referrals" INTEGER[],
    "Bubbles" INTEGER NOT NULL,
    "isAdmin" BOOLEAN NOT NULL,
    "uid" TEXT NOT NULL DEFAULT '0',
    "Image" TEXT NOT NULL,
    "NFM" INTEGER NOT NULL,
    "NormalConsp" INTEGER NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("uid")
);

-- CreateTable
CREATE TABLE "Request" (
    "id" SERIAL NOT NULL,
    "status" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "desc" TEXT NOT NULL,

    CONSTRAINT "Request_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_UserLikedEvents" (
    "A" INTEGER NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_UserParticipatedEvents" (
    "A" INTEGER NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_UserLikedNews" (
    "A" INTEGER NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Request_id_key" ON "Request"("id");

-- CreateIndex
CREATE UNIQUE INDEX "_UserLikedEvents_AB_unique" ON "_UserLikedEvents"("A", "B");

-- CreateIndex
CREATE INDEX "_UserLikedEvents_B_index" ON "_UserLikedEvents"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_UserParticipatedEvents_AB_unique" ON "_UserParticipatedEvents"("A", "B");

-- CreateIndex
CREATE INDEX "_UserParticipatedEvents_B_index" ON "_UserParticipatedEvents"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_UserLikedNews_AB_unique" ON "_UserLikedNews"("A", "B");

-- CreateIndex
CREATE INDEX "_UserLikedNews_B_index" ON "_UserLikedNews"("B");

-- AddForeignKey
ALTER TABLE "Bill" ADD CONSTRAINT "Bill_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("uid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CreditCard" ADD CONSTRAINT "CreditCard_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("uid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserLikedEvents" ADD CONSTRAINT "_UserLikedEvents_A_fkey" FOREIGN KEY ("A") REFERENCES "Events"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserLikedEvents" ADD CONSTRAINT "_UserLikedEvents_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("uid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserParticipatedEvents" ADD CONSTRAINT "_UserParticipatedEvents_A_fkey" FOREIGN KEY ("A") REFERENCES "Events"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserParticipatedEvents" ADD CONSTRAINT "_UserParticipatedEvents_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("uid") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserLikedNews" ADD CONSTRAINT "_UserLikedNews_A_fkey" FOREIGN KEY ("A") REFERENCES "News"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_UserLikedNews" ADD CONSTRAINT "_UserLikedNews_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("uid") ON DELETE CASCADE ON UPDATE CASCADE;
