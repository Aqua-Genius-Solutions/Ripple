const spendPoints = async (req, res) => {
  const uid = req.params.id;
  const pointsToSpend = req.body.points;

  try {
    const user = await prisma.user.findUnique({ where: { uid } });

    if (user.points < pointsToSpend) {
      res.status(400).json({ error: "Not enough points to spend." });
      return;
    }

    await prisma.user.update({
      where: { uid },
      data: { points: user.points - pointsToSpend },
    });

    res.json({ success: "Points spent successfully." });
  } catch (error) {
    res.status(500).json(error);
  }
};

module.exports = { getAllRewardItems, spendPoints };