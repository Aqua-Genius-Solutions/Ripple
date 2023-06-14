const router = require("express").Router();
const {
  signup,
  getUsers,
  createProfile,
  getOne,
  getAdminUser,
  getProUser,
} = require("../controllers/authController");
router.get("/pro", getProUser);
router.get("/admin", getAdminUser);

router.get("/getUsers", getUsers);
router.get("/getOne/:uid", getOne);

router.post("/login");
router.post("/signup", signup);

router.put("/profile/:uid", createProfile);

module.exports = router;
