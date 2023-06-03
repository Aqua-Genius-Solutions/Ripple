const router = require("express").Router();
const { getEvents } = require("../controllers/event");

router.get("/", getEvents);

module.exports = router;