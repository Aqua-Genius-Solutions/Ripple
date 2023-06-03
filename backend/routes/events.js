const router = require("express").Router();
const { getEvents } = require("../controllers/event");

router.get("/events", getEvents);

module.exports = router;