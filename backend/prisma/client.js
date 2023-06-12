
const  { PrismaClient } = require( "@prisma/client")
const prisma = new PrismaClient()

async function main() {
    const newUser = await prisma.user.create({
      data: {
        name: "Nour",
        surname: "Aloui",
        email: "nour.aloui@example.com",
        address: "123 fdfed St",
        isPro: false,
        Referrals: [],
        Bubbles: 0,
        Reference: 0,
        isAdmin: false,
        uid: "1234",
        Image: "",
        Bill: {
          create: [
            {
              price: 100,
              NFM: 3,
              consumption: 37,
              NormalConsp: 27,
              paid: false,
              startDate: new Date("2023-01-31T23:00:00.000Z"),
              endDate: new Date("2023-04-30T23:00:00.000Z"),
            },
            {
              price: 50,
              NFM: 3,
              consumption: 24,
              NormalConsp: 27,
              paid: false,
              startDate: new Date("2023-04-30T23:00:00.000Z"),
              endDate: new Date("2023-07-29T23:00:00.000Z"),
            },
            {
              price: 80,
              NFM: 3,
              consumption: 27,
              NormalConsp: 27,
              paid: false,
              startDate: new Date("2023-07-31T23:00:00.000Z"),
              endDate: new Date("2023-10-29T23:00:00.000Z"),
            },
            {
              price: 60,
              NFM: 3,
              consumption: 30,
              NormalConsp: 27,
              paid: false,
              startDate: new Date("2023-10-31T23:00:00.000Z"),
              endDate: new Date("2024-01-30T23:00:00.000Z"),
            },
          ],
        },
        creditCards: {
          create: [],
        },
        LikedEvents: {
          create: [],
        },
        LikedNews: {
          create: [],
        },
      },
    });
  
    console.log("New user created:", newUser);
  }
  
  main()
    .catch((e) => {
      console.error(e.message);
    })
    .finally(async () => {
      await prisma.$disconnect();
  });
  
  module.exports = prisma;
    


