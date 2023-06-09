const router = require("express").Router();
const { getAllNews } = require("../controllers/newsController");

router.get("/", getAllNews);

module.exports = router;
