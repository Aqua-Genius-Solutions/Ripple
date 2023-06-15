const router = require("express").Router();
const { updateUser ,getUserLikedItems } = require('../controllers/profile')

router.put("/:userId",updateUser);
router.get("/:email",getUserLikedItems)


module.exports = router;
