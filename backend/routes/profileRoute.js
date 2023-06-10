const router = require("express").Router();
const { updateUser } = require('../controllers/profile')

router.put("/:userId",updateUser);


module.exports = router;
