const express = require('express');
const quotesRouter = require('./quotes');
const transfersRouter = require('./transfers');

const router = express.Router();

router.use('/quotes', quotesRouter);
router.use('/transfers', transfersRouter);

module.exports = router;
