const { Router } = require("express");
const authController = require("../controllers/auth.controller");
const firebaseAuthMiddleware = require("../middlewares/firebase-auth.middleware");
const validateRequest = require("../middlewares/validate-request.middleware");
const {
  loginSchema,
  refreshSchema,
  registerSchema,
} = require("../validations/auth.validation");

const router = Router();

router.post("/auth/register", validateRequest(registerSchema), authController.register);
router.post("/auth/login", validateRequest(loginSchema), authController.login);
router.post("/auth/refresh", validateRequest(refreshSchema), authController.refresh);
router.get("/auth/me", firebaseAuthMiddleware, authController.me);

module.exports = router;
