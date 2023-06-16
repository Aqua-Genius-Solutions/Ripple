const router = require("express").Router();
const { getBill, addBill, getBillsByUser } = require("../controllers/bill.js");

router.get("/", getBill);
router.get("/user/:uid", getBillsByUser);
router.post("/add", addBill);

module.exports = router;
