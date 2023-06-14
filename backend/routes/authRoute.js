const router = require("express").Router();
const {
  signup,
  getUsers,
  createProfile,
  getAdminUser , getProUser
} = require("../controllers/authController");
router.get("/pro", getProUser);
router.get("/admin", getAdminUser);

router.get("/getUsers", getUsers);


router.post("/login");
router.post("/signup", signup);

router.put("/profile/:uid", createProfile);

module.exports = router;
