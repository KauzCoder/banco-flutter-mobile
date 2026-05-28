const pixKeyService = require('../services/pix-key.service');

async function createPixKey(req, res, next) {
  try {
    const userId = req.headers['x-user-id'] || req.body.userId;
    const pixKey = await pixKeyService.createPixKey({
      ...req.body,
      userId,
    });

    return res.status(201).json(pixKey);
  } catch (error) {
    return next(error);
  }
}

async function getPixKeys(req, res, next) {
  try {
    const userId = req.headers['x-user-id'] || req.query.userId;
    const pixKeys = await pixKeyService.getPixKeys(userId);

    return res.status(200).json(pixKeys);
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  createPixKey,
  getPixKeys,
};
