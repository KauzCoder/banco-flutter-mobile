const { Router } = require("express");
const authController = require("../controllers/auth.controller");
const firebaseAuthMiddleware = require("../middlewares/firebase-auth.middleware");

const router = Router();

router.post("/auth/register", authController.register);
router.post("/auth/login", authController.login);
router.post("/auth/refresh", authController.refresh);
router.get("/auth/me", firebaseAuthMiddleware, authController.me);

module.exports = router;
