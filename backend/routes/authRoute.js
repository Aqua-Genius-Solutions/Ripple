const router = require("express").Router();
const {
  signup,
  getUsers,
  createProfile,
  getAdminUser , getProUser
} = require("../controllers/authController");

router.get("/getUsers", getUsers);
router.get("/pro", getProUser);
router.get("/admin", getAdminUser);

router.post("/login");
router.post("/signup", signup);

router.put("/profile/:uid", createProfile);

module.exports = router;
