const { Router } = require("express");
const userSettingsController = require("../controllers/user-settings.controller");
const firebaseAuthMiddleware = require("../middlewares/firebase-auth.middleware");

const router = Router();

router.use(firebaseAuthMiddleware);

router.get("/user-settings", userSettingsController.getUserSettings);
router.patch("/user-settings", userSettingsController.updateUserSettings);

module.exports = router;
