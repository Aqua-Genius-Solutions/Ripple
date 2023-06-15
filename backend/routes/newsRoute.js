const express = require("express");
const router = express.Router();
const { getAllNews, likeNews, addComment } = require("../controllers/newsController");

router.put('/:newsId/like/:userId', likeNews);
router.get("/", getAllNews);
// router.patch("/:id/like", likeNews); // This line is commented out, so it won't affect your routes.

module.exports = router;