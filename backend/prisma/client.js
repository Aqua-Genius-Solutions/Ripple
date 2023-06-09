

const  { PrismaClient } = require( "@prisma/client")
const prisma = new PrismaClient()


// async function main() {
//     const user = await prisma.user.create({
//         data: {
//             name: "Nour",
//             surname: "Aloui",
//             email: "nour.aloui@example.com",
//             password: "password123",
//             address: "123 Main St",
//             isPro: false,
//             creditCard: BigInt(1234567890),
//             CVC: 123,
//             Referrals: [],
//             Bubbles: BigInt(0),
//             Reference: 1,
//             isAdmin: false,
//             NbFamMem: 2,
//             LikedEvents: { connect: [2] },
//             LikedNews: { connect: [] } 
//         }
//     })
//     console.log(user)
//     // const users= await prisma.user.findMany()
//     // console.log(users)

    // const newEvent = await prisma.events.create({
    //     data: {
    //         author: "Save Water",
    //         link: "https://example.com/event",
    //         date: new Date(),
    //         participants: [1,0,3],
    //         image: "https://th.bing.com/th/id/OIP.ujrkaVK1XnEU9Hpe5W5qfwHaE8?pid=ImgDet&rs=1",
    //         LikedBy: {
    //             connect: { id: 4 } // Connects the event to a specific user with ID 1
    //         }
    //     },
    // })
    // console.log("New event created:", newEvent)

//     const newNews = await prisma.news.create({
//         data: {
//             author: "John Doe",
//             description: "Exciting news!",
//             link: "https://example.com/news",
//             date: new Date(),
//             image: "news_image.jpg",
//             LikedBy: {
//                 connect: { id: 1 } // Connects the news to a specific user with ID 1
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
