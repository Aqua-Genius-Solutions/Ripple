const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const getAllNews = async (req, res) => {
  const news = await prisma.news.findMany();
  res.json(news);
};

const likeNews = async (req, res) => {
  const { id } = req.params;
  const news = await prisma.news.update({
    where: { id: parseInt(id) },
    data: { likes: { increment: 1 } },
  });
  res.json(news);
};

const addComment = async (req, res) => {
  const { id } = req.params;
  const { content, author } = req.body;
  const comment = await prisma.comment.create({
    data: {
      content,
      author,
      news: { connect: { id: parseInt(id) } },
    },
  });
  res.json(comment);
};

module.exports = { getAllNews, likeNews, addComment };