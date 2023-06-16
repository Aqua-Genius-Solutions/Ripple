const prisma = require("../prisma/client");

const getAllRewardItems = async (req, res) => {
  const rewardItems = await prisma.rewards.findMany();
  res.json(rewardItems);
};
const updateUserPoints = async (req, res) => {
  const { uid, points } = req.body;

  try {
    const user = await prisma.user.update({
      where: { uid },
      data: { Bubbles: points },
    });

    res.json(user);
  } catch (error) {
    res.status(400).json({ error: "Failed to update user points" });
  }
};

module.exports = { getAllRewardItems, updateUserPoints };