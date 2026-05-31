const { Router } = require("express");
const cardController = require("../controllers/card.controller");
const firebaseAuthMiddleware = require("../middlewares/firebase-auth.middleware");

const router = Router();

router.use(firebaseAuthMiddleware);
router.get("/cards", cardController.getCards);

module.exports = router;
