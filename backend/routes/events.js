const router = require("express").Router();
const { getEvents, likeEvent, participateInEvent } = require("../controllers/event");


router.put('/:eventId/like/:userId', likeEvent);
router.get("/", getEvents);
router.put("/:eventId/part/:userId", participateInEvent);





module.exports = router; 