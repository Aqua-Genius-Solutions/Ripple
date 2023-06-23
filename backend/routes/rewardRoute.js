const router = require("express").Router();
const { getAllRewardItems, spendPoints } = require("../controllers/rewardController");

router.get("/", getAllRewardItems);
router.put("/:id/spend-points", spendPoints);

module.exports = router;