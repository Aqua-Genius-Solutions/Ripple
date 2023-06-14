const prisma = require("../prisma/client");

const addCard = async (req, res) => {
  const uid = req.params.uid;

  try {
    console.log(req.body);
    let { number, CVC, expDate } = req.body;
    const user = await prisma.user.findUnique({
      where: { uid },
    });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    number = number.split(" ").join("");
    console.log(number);
    const card = await prisma.creditCard.create({
      data: {
        number,
        CVC: Number(CVC),
        expDate: new Date(),
        balance: Math.floor(Math.random() * (9999 - 1000 + 1)) + 1000,
        owner: {
          connect: { uid },
        },
      },
    });

    return res.status(201).json(card);
  } catch (error) {
    console.error("Error adding credit card:", error);
    return res.status(500).json({ error: "Failed to add credit card" });
  }
};

const getCreditCards = async (req, res) => {
  const uid = req.params.uid;
  try {
    const creditCards = await prisma.creditCard.findMany({
      where: { ownerId: uid },
    });
    res.status(200).json(creditCards);
  } catch (error) {
    console.error("Error adding credit card:", error);
    return res.status(500).json({ error: "Failed to add credit card" });
  }
};

module.exports = { addCard, getCreditCards };
