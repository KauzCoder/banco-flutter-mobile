const { Router } = require("express");
const accountController = require("../controllers/account.controller");
const firebaseAuthMiddleware = require("../middlewares/firebase-auth.middleware");

const router = Router();

router.use(firebaseAuthMiddleware);

router.get("/account/balance", accountController.getBalance);
router.get("/account/summary", accountController.getSummary);

module.exports = router;
