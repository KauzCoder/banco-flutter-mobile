const { Router } = require("express");
const pixKeyController = require("../controllers/pix-key.controller");
const firebaseAuthMiddleware = require("../middlewares/firebase-auth.middleware");

const router = Router();

router.use(firebaseAuthMiddleware);

router.post("/pix-keys", pixKeyController.createPixKey);
router.get("/pix-keys", pixKeyController.getPixKeys);

module.exports = router;
