const router = require("express").Router();
const {
  addCard,
  getCreditCards,
  pay,
} = require("../controllers/paymentController");

router.get("/user/:uid", getCreditCards);

router.post("/add/:uid", addCard);

router.put("/pay/:billId/:cardId", pay);

module.exports = router;
