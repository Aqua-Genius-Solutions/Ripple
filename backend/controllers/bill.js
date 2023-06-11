const prisma = require("../prisma/client");

const getBill = async (req, res) => {
  console.log(await prisma.bill.findMany());
  const bill = await prisma.bill.findMany({
    orderBy: {
      id: "desc",
    },
    take: 4, // Get only 4 bills
  });
  res.json(bill);
};

const addBill = async (req, res) => {
  try {
    const { price, consumption, paid, userId, startDate, endDate, imageUrl } =
      req.body;
    console.log("adding bill", req.body);

    const bill = await prisma.bill.create({
      data: {
        price,
        consumption,
        NFM: 4,
        NormalConsp: 36,
        paid,
        imageUrl,
        user: {
          connect: { uid: userId },
        },
        startDate: new Date(startDate) || new Date(),
        endDate: new Date(endDate) || new Date(),
      },
    });

    return res.status(201).json(bill);
  } catch (error) {
    console.error("Error adding bill:", error);
    return res.status(500).json({ error: "Failed to add bill" });
  }
};

module.exports = { getBill, addBill };
