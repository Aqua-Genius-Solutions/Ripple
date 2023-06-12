const router = require("express").Router();
const { getAllRewardItems } = require("../controllers/rewardController");

router.get("/", getAllRewardItems);

module.exports = router;