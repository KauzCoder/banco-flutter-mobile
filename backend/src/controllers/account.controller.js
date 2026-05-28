const accountService = require('../services/account.service');

async function getBalance(req, res, next) {
  try {
    const userId = req.headers['x-user-id'] || req.query.userId;
    const balance = await accountService.getBalance(userId);

    return res.status(200).json(balance);
  } catch (error) {
    return next(error);
  }
}

async function getSummary(req, res, next) {
  try {
    const userId = req.headers['x-user-id'] || req.query.userId;
    const summary = await accountService.getSummary(userId);

    return res.status(200).json(summary);
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  getBalance,
  getSummary,
};
