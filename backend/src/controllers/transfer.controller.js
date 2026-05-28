const transferService = require('../services/transfer.service');

async function createTransfer(req, res, next) {
  try {
    const fromUserId = req.headers['x-user-id'] || req.body.fromUserId;
    const transfer = await transferService.createTransfer({
      ...req.body,
      fromUserId,
    });

    return res.status(201).json(transfer);
  } catch (error) {
    return next(error);
  }
}

async function getHistory(req, res, next) {
  try {
    const userId = req.headers['x-user-id'] || req.query.userId;
    const transfers = await transferService.getTransferHistory(userId);

    return res.status(200).json(transfers);
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  createTransfer,
  getHistory,
};
