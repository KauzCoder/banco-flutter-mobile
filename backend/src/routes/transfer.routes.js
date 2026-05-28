const { Router } = require("express");
const transferController = require("../controllers/transfer.controller");
const firebaseAuthMiddleware = require("../middlewares/firebase-auth.middleware");

const router = Router();

router.use(firebaseAuthMiddleware);

router.post("/transfers", transferController.createTransfer);
router.get("/transfers/history", transferController.getHistory);

module.exports = router;
