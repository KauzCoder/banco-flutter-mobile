const userSettingsService = require('../services/user-settings.service');

async function getUserSettings(req, res, next) {
  try {
    const userId = req.headers['x-user-id'] || req.query.userId;
    const settings = await userSettingsService.getUserSettings(userId);

    return res.status(200).json(settings);
  } catch (error) {
    return next(error);
  }
}

async function updateUserSettings(req, res, next) {
  try {
    const userId = req.headers['x-user-id'] || req.body.userId;
    const settings = await userSettingsService.updateUserSettings(userId, req.body);

    return res.status(200).json(settings);
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  getUserSettings,
  updateUserSettings,
};
