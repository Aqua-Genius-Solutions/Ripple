const prisma = require("../prisma/client");

const addCard = async (req, res) => {
  const { userId, number, CVC, expDate } = req.body;

  try {
    const user = await prisma.user.findUnique({
      where: { uid: userId },
    });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const card = await prisma.creditCard.create({
      data: {
        number,
        CVC,
        expDate,
        owner: {
          connect: { uid: userId },
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
