const router = require("express").Router();
const {
  signup,
  getUsers,
  createProfile,
  getOne,
  getAdminUser,
  getProUser,
  getImage,
  createNewRequest,
} = require("../controllers/authController");

router.get("/pro", getProUser);
router.get("/admin", getAdminUser);

router.get("/getUsers", getUsers);
router.get("/getOne/:uid", getOne);

router.post("/signup", signup);
router.get("/getone/:uid", getImage);

router.put("/profile/:uid", createProfile);

router.post("/request/:uid", createNewRequest);

module.exports = router;
