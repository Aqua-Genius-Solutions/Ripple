const prisma = require("../prisma/client");

const getAllRewardItems = async (req, res) => {
  try {
    const rewardItems = await prisma.rewards.findMany();
    console.log(rewardItems);
    res.json(rewardItems);
  } catch (error) {
    res.status(500).json(error);
  }
};

module.exports = { getAllRewardItems };
