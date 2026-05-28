const { Router } = require('express');
const pixKeyController = require('../controllers/pix-key.controller');

const router = Router();

router.post('/pix-keys', pixKeyController.createPixKey);
router.get('/pix-keys', pixKeyController.getPixKeys);

module.exports = router;
