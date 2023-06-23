const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

const getAllNews = async (req, res) => {
  try {
    const news = await prisma.news.findMany();
    res.json(news);
  } catch (error) {
    console.error("An error occurred:", error);
    res
      .status(500)
      .json({ error: "An error occurred while fetching news articles" });
  }
};

const likeNews = async (req, res) => {
  const newsId = parseInt(req.params.newsId);
  const userId = req.params.userId;

  try {
    const user = await prisma.user.findUnique({
      where: { uid: userId },
    });

    await prisma.news.update({
      where: { id: newsId },
      data: { User: { connect: [{ uid: userId }] } },
    });

    const news = await prisma.news.findFirst({
      where: { id: newsId },
      include: { User: true },
    });

    const numLikes = news.User.length;

    await prisma.user.update({
      where: { uid: userId },
      data: { News: user.News },
    });

    res.json({
      message: "News liked successfully",
      userLiked: news.User,
      numLikes,
    });
  } catch (error) {
    console.error("An error occurred:", error);
    res.status(500).json({ error: "An error occurred while liking the news" });
  }
};

const getUserLikedNews = async (req, res) => {
  const uid = req.params.uid;

  try {
    const user = await prisma.user.findFirst({
      where: { uid },
      include: { News: true },
    });

    res.status(200).json(user?.News);
  } catch (error) {
    console.error("An error occurred:", error);
    res
      .status(500)
      .json({ error: "An error occurred while fetching user's liked news" });
  }
};

module.exports = { getAllNews, likeNews, getUserLikedNews };
