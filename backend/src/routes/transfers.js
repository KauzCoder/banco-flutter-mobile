const express = require('express');
const { createTransfer } = require('../controllers/transfersController');

const router = express.Router();

router.post('/', createTransfer);

module.exports = router;
