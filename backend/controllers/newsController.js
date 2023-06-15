const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const getAllNews = async (req, res) => {
  const news = await prisma.news.findMany();
  res.json(news);
};

const likeNews = async (req, res) => {
  const newsId = parseInt(req.params.newsId);
  const userId = req.params.userId;
  console.log(newsId, userId);

  try {
    const user = await prisma.user.findUnique({
      where: { uid: userId },
    });

    const updatedNews = await prisma.news.update({
      where: { id: newsId },
      data: { LikedBy: { connect: { uid: userId } } },
    });
    console.log(updatedNews);

    const news = await prisma.news.findFirst({
      where: { id: newsId },
      include: { LikedBy: true },
    });
    console.log(news.LikedBy);
    const numLikes = news.LikedBy.length;

    await prisma.user.update({
      where: { uid: userId },
      data: { LikedNews: user.LikedNews },
    });

    res.json({ message: 'News liked successfully', numLikes });
  } catch (error) {
    console.error('An error occurred:', error);
    res.status(500).json({ error: 'An error occurred while liking the news' });
  }
};


module.exports = { getAllNews, likeNews };