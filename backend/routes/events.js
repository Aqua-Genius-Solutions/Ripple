const router = require("express").Router();
const {
  getEvents,
  likeEvent,
  participateInEvent,
  getUserLikedEvents,
} = require("../controllers/event");

router.get("/", getEvents);
router.get("/user/:uid", getUserLikedEvents);

router.put("/:eventId/like/:userId", likeEvent);
router.put("/:eventId/part/:userId", participateInEvent);

module.exports = router;
