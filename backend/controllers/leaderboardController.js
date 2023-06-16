const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

exports.getLeaderboard = async (req, res) => {
  try {
    const users = await prisma.user.findMany({
      orderBy: [
        {
          Bubbles: 'desc',
        },
      ],
      select: {
        name: true,
        surname: true,
        Bubbles: true,
        Image: true,
      },
    });

    res.status(200).json({
      status: 'success',
      data: users,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      status: 'error',
      message: 'An error occurred while fetching the leaderboard data.',
    });
  }
};