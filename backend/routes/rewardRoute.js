const router = require("express").Router();
const {
  getAllRewards,
  spendPoints,
} = require("../controllers/rewardController");

router.get("/", getAllRewards);
router.put("/:id/spend-points", spendPoints);

module.exports = router;
