const router = require("express").Router();
const { getUsers } = require("../controllers/controller");

router.get("/", getUsers);

module.exports = router;
