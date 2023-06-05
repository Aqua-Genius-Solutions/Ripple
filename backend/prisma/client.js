

const  { PrismaClient } = require( "@prisma/client")
const prisma = new PrismaClient()


// async function main() {
//     const user = await prisma.user.create({
//         data: {
//             uid: "55",
//             name: "John",
//             surname: "Doe",
//             email: "johndoe@example.com",
//             address: "123 Main St",
//             isPro: false,
//             creditCard: 1234567890,
//             CVC: 123,
//             Referrals: [],
//             Bubbles: 0,
//             Reference: 1,
//             isAdmin: false,
//             NbFamMem: 2,
//             LikedEvents: { connect: [1] },
//             LikedNews: { connect: [3] } 
//         }
//     })
//     console.log(user)
    // const users= await prisma.user.findMany()
    // console.log(users)

//     const newEvent = await prisma.events.create({
//         data: {
//             author: "",
//             link: "https://example.com/event",
//             date: new Date(),
//             participants: [],
//             image: "event_image.jpg",
//             LikedBy: {
//                 connect: [] // Connects the event to a specific user with ID 1
//             }
//         },
//     })
//     console.log("New event created:", newEvent)

//     const newNews = await prisma.news.create({
//         data: {
//             author: "John Doe",
//             description: "Exciting news!",
//             link: "https://example.com/news",
//             date: new Date(),
//             image: "news_image.jpg",
//             LikedBy: {
//                 connect: [] // Connects the news to a specific user with ID 1
//             }
//         },
//     })

//     console.log("New news created:", newNews)
// }

// main()
//     .catch(e => {
//         console.error(e.message)
//     })
//     .finally(async () => {
//         await prisma.$disconnect
//     })


module.exports = prisma;
