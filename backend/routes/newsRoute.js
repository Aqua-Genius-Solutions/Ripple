const express = require("express");
const router = express.Router();
const { getAllNews, likeNews, addComment } = require("../controllers/newsController");

router.get("/", getAllNews);
router.patch("/:id/like", likeNews);
router.post("/:id/comment", addComment);

module.exports = router;