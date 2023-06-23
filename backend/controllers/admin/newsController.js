const prisma = require("../../prisma/client");

async function getNews(req, res) {
  try {
    const news = await prisma.news.findMany({ include: { User: true } });
    res.json(news);
  } catch (error) {
    res.status(500).json({ message: "Error fetching news", error });
  }
}

async function createNews(req, res) {
  try {
    const newNews = req.body;
    const createdNews = await prisma.news.create({
      data: { ...newNews, User: { connect: [] } },
    });
    res.json(createdNews);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Error creating news", error });
  }
}

async function updateNews(req, res) {
  try {
    const { id } = req.params;
    const updates = req.body;
    const updatedNews = await prisma.news.update({
      where: { id: Number(id) },
      data: updates,
    });
    res.json(updatedNews);
  } catch (error) {
    res.status(500).json({ message: "Error updating news", error });
  }
}

async function deleteNews(req, res) {
  try {
    const { id } = req.params;
    const deletedNews = await prisma.news.delete({
      where: { id: Number(id) },
    });
    res.json(deletedNews);
  } catch (error) {
    console.log(error);
    res.status(500).json({ message: "Error deleting news", error });
  }
}

module.exports = {
  getNews,
  createNews,
  updateNews,
  deleteNews,
};
