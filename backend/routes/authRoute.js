const router = require("express").Router();
const {
  signup,
  getUsers,
  createProfile,
} = require("../controllers/authController");

router.get("/getUsers", getUsers);

router.post("/login");
router.post("/signup", signup);

router.put("/profile/:uid", createProfile);

module.exports = router;
