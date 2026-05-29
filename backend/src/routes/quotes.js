const express = require('express');
const { getQuotes } = require('../controllers/quotesController');

const router = express.Router();

router.get('/', getQuotes);

module.exports = router;
