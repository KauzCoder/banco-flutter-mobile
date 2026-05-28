const { Router } = require('express');
const userSettingsController = require('../controllers/user-settings.controller');

const router = Router();

router.get('/user-settings', userSettingsController.getUserSettings);
router.patch('/user-settings', userSettingsController.updateUserSettings);

module.exports = router;
