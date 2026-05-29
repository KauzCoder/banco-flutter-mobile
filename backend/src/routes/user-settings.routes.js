const { Router } = require("express");
const userSettingsController = require("../controllers/user-settings.controller");
const firebaseAuthMiddleware = require("../middlewares/firebase-auth.middleware");
const validateRequest = require("../middlewares/validate-request.middleware");
const {
  updateUserSettingsSchema,
} = require("../validations/user-settings.validation");

const router = Router();

router.use(firebaseAuthMiddleware);

router.get("/user-settings", userSettingsController.getUserSettings);
router.patch(
  "/user-settings",
  validateRequest(updateUserSettingsSchema),
  userSettingsController.updateUserSettings,
);

module.exports = router;
