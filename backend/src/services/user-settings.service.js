const userSettingsRepository = require('../repositories/user-settings.repository');

async function getUserSettings(userId) {
  if (!userId) {
    const error = new Error('Informe o userId.');
    error.statusCode = 400;
    throw error;
  }

  const settings = await userSettingsRepository.findUserSettingsByUserId(userId);

  if (!settings) {
    return userSettingsRepository.createUserSettings(userId);
  }

  return settings;
}

async function updateUserSettings(userId, settingsData) {
  if (!userId) {
    const error = new Error('Informe o userId.');
    error.statusCode = 400;
    throw error;
  }

  return userSettingsRepository.updateUserSettings(userId, settingsData);
}

module.exports = {
  getUserSettings,
  updateUserSettings,
};
