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
      include: { owner: true },
    });
    res.status(200).json(creditCards);
  } catch (error) {
    console.error("Error adding credit card:", error);
    return res.status(500).json({ error: "Failed to add credit card" });
  }
};

const pay = async (req, res) => {
  const { billId, cardId } = req.params;
  const bId = Number(billId);
  const cId = Number(cardId);
  if (isNaN(bId) || isNaN(cId)) {
    return res.status(400).json({ error: "Invalid billId or cardId" });
  }
  try {
    const bill = await prisma.bill.findFirst({ where: { id: bId } });
    const creditCard = await prisma.creditCard.findFirst({
      where: { id: cId },
    });
    console.log(creditCard);
    if (!bill || !creditCard) {
      return res.status(404).json({ error: "Bill or credit card not found" });
    }
    if (creditCard.balance < bill.price) {
      return res.status(400).json({ error: "Insufficient funds" });
    }
    const newBalance = Math.floor(creditCard.balance - bill.price);
    const updatedCreditCard = await prisma.creditCard.update({
      where: { id: cId },
      data: { balance: newBalance },
    });
    console.log("credit card updated:", updatedCreditCard);
    await prisma.bill.update({
      where: { id: bId },
      data: { paid: true },
    });
    console.log("bill paid");
    res.status(200).json("Bill paid successfully");
  } catch (error) {
    console.error("Error paying bill:", error);
    return res.status(500).json({ error: "Failed to pay the bill" });
  }
};
module.exports = { addCard, getCreditCards, pay };
