const prisma = require("../prisma/client");

const getUsers = async (req, res) => {
  const users = await prisma.user.findMany({
    include: { LikedEvents: true, LikedNews: true, bills: true },
  });
  res.json(users);
};

module.exports = { getUsers };
