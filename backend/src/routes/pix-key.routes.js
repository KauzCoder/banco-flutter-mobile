const { Router } = require("express");
const pixKeyController = require("../controllers/pix-key.controller");
const firebaseAuthMiddleware = require("../middlewares/firebase-auth.middleware");
const validateRequest = require("../middlewares/validate-request.middleware");
const {
  createPixKeySchema,
} = require("../validations/pix-key.validation");

const router = Router();

router.use(firebaseAuthMiddleware);

router.post(
  "/pix-keys",
  validateRequest(createPixKeySchema),
  pixKeyController.createPixKey,
);
router.get("/pix-keys", pixKeyController.getPixKeys);

module.exports = router;
