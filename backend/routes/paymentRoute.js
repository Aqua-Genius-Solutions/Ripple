const router = require("express").Router();
const { addCard, getCreditCards } = require("../controllers/paymentController");

router.get("/user/:uid", getCreditCards);

router.post("/add/:uid", addCard);

module.exports = router;
