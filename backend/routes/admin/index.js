const router = require("express").Router();

const authorize = require("../../middleware/authorize");

const eventsController = require("../../controllers/admin/eventsController");
const newsController = require("../../controllers/admin/newsController");
const rewardsController = require("../../controllers/admin/rewardsController");
const usersController = require("../../controllers/admin/usersController");

// Use authorize middleware
// router.use(authorize);

// Routes for Events
router.get("/events", eventsController.getEvents);
router.post("/events", eventsController.createEvent);
router.put("/events/:id", eventsController.updateEvent);
router.delete("/events/:id", eventsController.deleteEvent);

// Routes for News
router.get("/news", newsController.getNews);
router.post("/news", newsController.createNews);
router.put("/news/:id", newsController.updateNews);
router.delete("/news/:id", newsController.deleteNews);

// Routes for Rewards
router.get("/rewards", rewardsController.getRewards);
router.post("/rewards", rewardsController.createReward);
router.put("/rewards/:id", rewardsController.updateReward);
router.delete("/rewards/:id", rewardsController.deleteReward);

// Routes for Users
router.put("/users/:id/admin", usersController.setAdminStatus);
router.put("/users/:id/pro", usersController.setProStatus);

module.exports = router;
