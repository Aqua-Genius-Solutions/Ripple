const prisma = require("../../prisma/client");

const getBills = async (req, res) => {
  try {
    const bills = await prisma.bill.findMany();
    console.log(bills);
    res.status(200).json(bills);
  } catch (error) {
    res.status(500).json({ message: "error finding bills", error });
  }
};

module.exports = { getBills };
