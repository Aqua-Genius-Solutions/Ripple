const express = require("express");
const router = express.Router();
const {
  getAllNews,
  likeNews,
  getUserLikedNews,
} = require("../controllers/newsController");

router.get("/", getAllNews);
router.get("/user/:uid", getUserLikedNews);

router.put("/:newsId/like/:userId", likeNews);

module.exports = router;
