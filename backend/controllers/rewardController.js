const prisma = require("../prisma/client");

const getAllRewardItems = async (req, res) => {
  const rewardItems = await prisma.rewards.findMany();
  res.json(rewardItems);
};


module.exports = { getAllRewardItems };