const pixKeyService = require("../services/pix-key.service");

function pixKeyDTO(pixKey) {
  if (!pixKey) {
    return null;
  }

  return {
    id: pixKey.id || pixKey.pixKeyId,
    userId: pixKey.userId || "",
    accountId: pixKey.accountId || "",
    tipo: pixKey.tipo || "",
    valor: pixKey.valor || "",
    ativa: pixKey.ativa ?? true,
    dataCriacao: pixKey.dataCriacao || null,
  };
}

async function createPixKey(req, res, next) {
  try {
    const userId = req.headers["x-user-id"] || req.body.userId;
    const pixKey = await pixKeyService.createPixKey({
      ...req.body,
      userId,
    });

    return res.status(201).json(pixKeyDTO(pixKey));
  } catch (error) {
    return next(error);
  }
}

async function getPixKeys(req, res, next) {
  try {
    const userId = req.headers["x-user-id"] || req.query.userId;
    const pixKeys = await pixKeyService.getPixKeys(userId);

    return res.status(200).json(pixKeys.map(pixKeyDTO));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  createPixKey,
  getPixKeys,
};
