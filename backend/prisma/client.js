

const { PrismaClient } = require("@prisma/client")
const prisma = new PrismaClient()

// async function main() {
//   const user1 = await prisma.user.create({
//     data: {
//       name: "John",
//       surname: "Doe",
//       email: "johndoe@example.com",
//       address: "123 Main St",
//       isPro: false,
//       Referrals: [2, 3],
//       Bubbles: 5,
//       isAdmin: false,
//       uid: "153465,4521",
//       Image: "https://example.com/images/johndoe.jpg",
//       NFM: 10,
//       NormalConsp: 5,
//       Bill: {
//         create: {
//           price: 100.0,
//           consumption: 50,
//           paid: true,
//           startDate: new Date("2022-01-01T00:00:00Z"),
//           endDate: new Date("2022-01-31T23:59:59Z"),
//           imageUrl: "https://example.com/images/bill.jpg",
//         },
//       },
//       creditCards: {
//         create: [
//           {
//             number: "1234567890123456",
//             CVC: 123,
//             expDate: new Date("2024-12-31T23:59:59Z"),
//             balance: 500,
//           },
//           {
//             number: "9876543210987654",
//             CVC: 456,
//             expDate: new Date("2025-12-31T23:59:59Z"),
//             balance: 1000,
//           },
//         ],
//       },
//       LikedEvents: {
//         create: [
//           {
//             link: "https://example.com/events/1",
//             date: new Date("2022-06-20T19:00:00Z"),
//             image: "https://example.com/images/event1.jpg",
//             title: "Event 1",
//           },
//           {
//             link: "https://example.com/events/2",
//             date: new Date("2022-07-01T13:00:00Z"),
//             image: "https://example.com/images/event2.jpg",
//             title: "Event 2",
//           },
//         ],
//       },
//       LikedNews: {
//         create: [
//           {
//             author: "Jane Smith",
//             description: "Lorem ipsum dolor sit amet.",
//             link: "https://example.com/news/1",
//             date: new Date("2022-06-15T12:00:00Z"),
//             image: "https://example.com/images/news1.jpg",
//             comments: {
//               create: [
//                 {
//                   content: "Great article!",
//                   author: "Bob Johnson",
//                 },
//               ],
//             },
//           },
//           {
//             author: "Bob Johnson",
//             description: "Consectetur adipiscing elit.",
//             link: "https://example.com/news/2",
//             date: new Date("2022-06-30T08:00:00Z"),
//             image: "https://example.com/images/news2.jpg",
//             comments: {
//               create: [
//                 {
//                   content: "I disagree with this.",
//                   author: "Jane Smith",
//                 },
//                 {
//                   content: "Interesting perspective.",
//                   author: "Alice Williams",
//                 },
//               ],
//             },
//           },
//         ],
//       },
//       Events_UserParticipatedEvents: {
//         create: [
//           {
//             link: "https://example.com/events/3",
//             date: new Date("2022-07-15T18:00:00Z"),
//             image: "https://example.com/images/event3.jpg",
//             title: "Event 3",
//           },
//         ],
//       },
//     },
//   });

//   const user2 = await prisma.user.create({
//     data: {
//       name: "Alice",
//       surname: "Williams",
//       email: "alicewilliams@example.com",
//       address: "456 Oak St",
//       isPro: true,
//       Referrals: [1],
//       Bubbles: 10,
//       isAdmin: false,
//       uid: "2876m546846",
//       Image: "https://example.com/images/alicewilliams.jpg",
//       NFM: 20,
//       NormalConsp: 10,
//       LikedEvents: {
//         create: [
//           {
//             link: "https://example.com/events/1",
//             date: new Date("2022-06-20T19:00:00Z"),
//             image: "https://example.com/images/event1.jpg",
//             title: "Event 1",
//           },
//           {
//             link: "https://example.com/events/2",
//             date: new Date("2022-07-01T13:00:00Z"),
//             image: "https://example.com/images/event2.jpg",
//             title: "Event 2",
//           },
//         ],
//       },
//       LikedNews: {
//         create: [
//           {
//             author: "Jane Smith",
//             description: "Lorem ipsum dolor sit amet.",
//             link: "https://example.com/news/1",
//             date: new Date("2022-06-15T12:00:00Z"),
//             image: "https://example.com/images/news1.jpg",
//             comments: {
//               create: [
//                 {
//                   content: "Great article!",
//                   author: "Bob Johnson",
//                 },
//               ],
//             },
//           },
//         ],
//       },
//       Events_UserParticipatedEvents: {
//         create: [
//           {
//             link: "https://example.com/events/3",
//             date: new Date("2022-07-15T18:00:00Z"),
//             image: "https://example.com/images/event3.jpg",
//             title: "Event 3",
//           },
//         ],
//       },
//     },
//   });

//   const event1 = await prisma.events.create({
//     data: {
//       link: "https://example.com/events/1",
//       date: new Date("2022-06-20T19:00:00Z"),
//       image: "https://example.com/images/event1.jpg",
//       title: "Event 1",
//       LikedBy: {
//         connect: [
//           {
//             uid: "1",
//           },
//           {
//             uid: "2",
//           },
//         ],
//       },
//       User_UserParticipatedEvents: {
//         connect: [
//           {
//             uid: "1",
//           },
//           {
//             uid: "2",
//           },
//         ],
//       },
//     },
//   });

//   const event2 = await prisma.events.create({
//     data: {
//       link: "https://example.com/events/2",
//       date: new Date("2022-07-01T13:00:00Z"),
//       image: "https://example.com/images/event2.jpg",
//       title: "Event 2",
//       LikedBy: {
//         connect: [
//           {
//             uid: "1",
//           },
//           {
//             uid: "2",
//           },
//         ],
//       },
//     },
//   });

//   const event3 = await prisma.events.create({
//     data: {
//       link: "https://example.com/events/3",
//       date: new Date("2022-07-15T18:00:00Z"),
//       image: "https://example.com/images/event3.jpg",
//       title: "Event 3",
//       User_UserParticipatedEvents: {
//         connect: [
//           {
//             uid: "1",
//           },
//           {
//             uid: "2",
//           },
//         ],
//       },
//     },
//   });

//   const news1 = await prisma.news.create({
//     data: {
//       author: "Jane Smith",
//       description: "Lorem ipsum dolor sit amet.",
//       link: "https://example.com/news/1",
//       date: new Date("2022-06-15T12:00:00Z"),
//       image: "https://example.com/images/news1.jpg",
//       comments: {
//         create: [
//           {
//             content: "Great article!",
//             author: "Bob Johnson",
//           },
//         ],
//       },
//       LikedBy: {
//         connect: [
//           {
//             uid: "1",
//           },
//           {
//             uid: "2",
//           },
//         ],
//       },
//     },
//   });

//   const news2 = await prisma.news.create({
//     data: {
//       author: "Bob Johnson",
//       description: "Consectetur adipiscing elit.",
//       link: "https://example.com/news/2",
//       date: new Date("2022-06-30T08:00:00Z"),
//       image: "https://example.com/images/news2.jpg",
//       comments: {
//         create: [
//           {
//             content: "I disagree with this.",
//             author: "Jane Smith",
//           },
//           {
//             content: "Interesting perspective.",
//             author: "Alice Williams",
//           },
//         ],
//       },
//       LikedBy: {
//         connect: [
//           {
//             uid: "1",
//           },
//         ],
//       },
//     },
//   });

//   const reward1 = await prisma.rewards.create({
//     data: {
//       name: "Free T-Shirt",
//       price: 100,
//       image: "https://example.com/images/tshirt.jpg",
//       description: "Get a free t-shirt with any purchase over $100.",
//     },
//   });

//   const comment1 = await prisma.comment.create({
//     data: {
//       content: "Great article!",
//       author: "Bob Johnson",
//       newsId: news1.id,
//     },
//   });

//   const comment2 = await prisma.comment.create({
//     data: {
//       content: "I disagree with this.",
//       author: "Jane Smith",
//       newsId: news2.id,
//     },
//   });

//   console.log("Dummy data created!");
// }
// main()
//   .catch((e) => console.error(e))
//   .finally(async () => {
//     await prisma.$disconnect()
//   })
module.exports = prisma;
