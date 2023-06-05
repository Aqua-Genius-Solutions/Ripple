const router = require("express").Router();
const { addCard } = require("../controllers/paymentController");

router.post("/", addCard);

module.exports = router;
