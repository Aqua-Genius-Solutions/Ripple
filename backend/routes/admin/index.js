const router = require("express").Router();

const authorize = require("../../middleware/authorize");

const eventsController = require("../../controllers/admin/eventsController");
const newsController = require("../../controllers/admin/newsController");
const rewardsController = require("../../controllers/admin/rewardsController");
const usersController = require("../../controllers/admin/usersController");
const billsController = require("../../controllers/admin/billsController");

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

// Routes for Bills
router.get("/bills", billsController.getBills);

// Routes for Users
router.get("/users", usersController.getUsers);
router.put("/users/:id/admin", usersController.setAdminStatus);
router.put("/users/:id/pro", usersController.setProStatus);

// Routes for Requests
router.get("/requests", usersController.getProRequests)
router.put("/requests/:id", usersController.manageProRequest)

module.exports = router;
