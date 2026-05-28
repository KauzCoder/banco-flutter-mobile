const { Router } = require('express');
const accountController = require('../controllers/account.controller');

const router = Router();

router.get('/account/balance', accountController.getBalance);
router.get('/account/summary', accountController.getSummary);

module.exports = router;
