const prisma = require("../prisma/client");
const getAllNews = async (req, res) => {
    const newsArticles = await prisma.news.findMany();
    res.json(newsArticles);
  }
  module.exports = {getAllNews}