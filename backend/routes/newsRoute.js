const express = require("express");
const router = express.Router();
const {
  getAllNews,
  likeNews,
  getUserLikedEvents,
} = require("../controllers/newsController");

router.get("/", getAllNews);
router.get("/user/:uid", getUserLikedEvents);

router.put("/:newsId/like/:userId", likeNews);

module.exports = router;
