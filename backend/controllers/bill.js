const prisma = require("../prisma/client");

const getBill = async (req, res) => {
  const bill = await prisma.bill.findMany({
    orderBy: {
      id: "desc",
    },
    take: 4, // Get only 4 bills
  });
  res.json(bill);
  console.log(bill);
};

const addBill = async (req, res) => {
  try {
    const { price, consumption, paid, userId, startDate, endDate } = req.body;

    const bill = await prisma.bill.create({
      data: {
        price,
        consumption,
        NFM: 4,
        NormalConsp: 36,
        paid,
        user: {
          connect: { uid: userId },
        },
        startDate: startDate || new Date(),
        endDate: endDate || new Date(),
      },
    });

    return res.status(201).json(bill);
  } catch (error) {
    console.error("Error adding bill:", error);
    return res.status(500).json({ error: "Failed to add bill" });
  }
};

module.exports = { getBill, addBill };
