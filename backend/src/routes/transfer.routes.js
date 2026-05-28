const { Router } = require('express');
const transferController = require('../controllers/transfer.controller');

const router = Router();

router.post('/transfers', transferController.createTransfer);
router.get('/transfers/history', transferController.getHistory);

module.exports = router;
