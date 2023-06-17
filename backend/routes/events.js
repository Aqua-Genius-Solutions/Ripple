const router = require("express").Router();
const { getEvents, likeEvent, participateInEvent,getLatest } = require("../controllers/event");


router.put('/:eventId/like/:userId', likeEvent);
router.get("/", getEvents);
router.put("/:eventId/part/:userId", participateInEvent);
router.get("/latest",getLatest)




module.exports = router;    