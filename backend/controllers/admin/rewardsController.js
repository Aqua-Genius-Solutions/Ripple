const prisma = require("../../prisma/client");

async function getRewards(req, res) {
  try {
    const rewards = await prisma.rewards.findMany();
    res.json(rewards);
  } catch (error) {
    res.status(500).json({ message: "Error fetching rewards", error });
  }
}

async function createReward(req, res) {
  try {
    const newRewards = req.body;
    const createdRewards = await prisma.rewards.create({ data: newRewards });
    res.json(createdRewards);
  } catch (error) {
    res.status(500).json({ message: "Error creating reward", error });
  }
}

async function updateReward(req, res) {
  try {
    const { id } = req.params;
    const updates = req.body;
    const updatedRewards = await prisma.rewards.update({
      where: { id: Number(id) },
      data: updates,
    });
    res.json(updatedRewards);
  } catch (error) {
    res.status(500).json({ message: "Error updating reward", error });
  }
}

async function deleteReward(req, res) {
  try {
    const { id } = req.params;
    const deletedRewards = await prisma.rewards.delete({
      where: { id: Number(id) },
    });
    res.json(deletedRewards);
  } catch (error) {
    res.status(500).json({ message: "Error deleting reward", error });
  }
}

module.exports = {
  getRewards,
  createReward,
  updateReward,
  deleteReward,
};
