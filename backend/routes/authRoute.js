const router = require("express").Router();
const {signup , getUsers} = require('../controllers/authController')
router.post("/login");
router.post("/signup",signup);
router.get("/getUsers",getUsers);

module.exports = router;
