const { Router } = require("express");
const transferController = require("../controllers/transfer.controller");
const firebaseAuthMiddleware = require("../middlewares/firebase-auth.middleware");
const validateRequest = require("../middlewares/validate-request.middleware");
const {
  createTransferSchema,
} = require("../validations/transfer.validation");

const router = Router();

router.use(firebaseAuthMiddleware);

router.post(
  "/transfers",
  validateRequest(createTransferSchema),
  transferController.createTransfer,
);
router.get("/transfers/history", transferController.getHistory);

module.exports = router;
