const router = require("express").Router();
const { getBill, addBill } = require("../controllers/bill.js");

router.get("/", getBill);
router.post("/add", addBill);

module.exports = router;