const { Router } = require('express');
const quoteController = require('../controllers/quote.controller');

const router = Router();

router.get('/quotes', quoteController.getQuotes);

module.exports = router;
