const { Router } = require("express");
const quoteController = require("../controllers/quote.controller");
const firebaseAuthMiddleware = require("../middlewares/firebase-auth.middleware");

const router = Router();

router.get("/quotes", firebaseAuthMiddleware, quoteController.getQuotes);

module.exports = router;
