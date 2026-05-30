const userSettingsService = require("../services/user-settings.service");

function userSettingsDTO(settings) {
  if (!settings) {
    return null;
  }

  return {
    id: settings.id || settings.userSettingsId,
    userId: settings.userId || "",
    biometriaAtiva: settings.biometriaAtiva ?? false,
    idioma: settings.idioma || "pt-BR",
    notificacoesAtivas: settings.notificacoesAtivas ?? true,
    temaEscuro: settings.temaEscuro ?? false,
  };
}

async function getUserSettings(req, res, next) {
  try {
    const userId = req.userId || req.headers["x-user-id"] || req.query.userId;
    const settings = await userSettingsService.getUserSettings(userId);

    return res.status(200).json(userSettingsDTO(settings));
  } catch (error) {
    return next(error);
  }
}

async function updateUserSettings(req, res, next) {
  try {
    const userId = req.userId || req.headers["x-user-id"] || req.body.userId;
    const settings = await userSettingsService.updateUserSettings(
      userId,
      req.body,
    );

    return res.status(200).json(userSettingsDTO(settings));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  getUserSettings,
  updateUserSettings,
};
