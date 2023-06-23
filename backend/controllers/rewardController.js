const prisma = require("../prisma/client");

const getAllRewards = async (req, res) => {
  try {
    const rewards = await prisma.rewards.findMany();

    res.status(200).json(rewards);
  } catch (error) {
    console.log(error);
    res.status(500).json(error);
  }
};

const spendPoints = async (req, res) => {
  const uid = req.params.id;
  const pointsToSpend = req.body.points;

  try {
    const user = await prisma.user.findUnique({ where: { uid } });

    if (user.Bubbles < pointsToSpend) {
      res.status(400).json({ error: "Not enough points to spend." });
      return;
    }

    await prisma.user.update({
      where: { uid },
      data: { Bubbles: user.Bubbles - pointsToSpend },
    });

    res.json({ success: "Points spent successfully." });
  } catch (error) {
    res.status(500).json(error);
  }
};

module.exports = { getAllRewards, spendPoints };
