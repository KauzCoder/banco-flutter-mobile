const transferService = require('../services/transfer.service');

function transferDTO(transfer) {
  if (!transfer) {
    return null;
  }

  return {
    id: transfer.id || transfer.transactionId,
    fromUserId: transfer.fromUserId || '',
    contaOrigemId: transfer.contaOrigemId || transfer.fromAccountId || '',
    contaDestinoId: transfer.contaDestinoId || transfer.toAccountId || '',
    nomeRecebedor: transfer.nomeRecebedor || '',
    chavePixRecebedor: transfer.chavePixRecebedor || '',
    descricao: transfer.descricao || '',
    status: transfer.status || '',
    tipo: transfer.tipo || '',
    valor: Number(transfer.valor || 0),
    dataHora: transfer.dataHora || null,
  };
}

async function createTransfer(req, res, next) {
  try {
    const fromUserId = req.headers['x-user-id'] || req.body.fromUserId;
    const transfer = await transferService.createTransfer({
      ...req.body,
      fromUserId,
    });

    return res.status(201).json(transferDTO(transfer));
  } catch (error) {
    return next(error);
  }
}

async function getHistory(req, res, next) {
  try {
    const userId = req.headers['x-user-id'] || req.query.userId;
    const transfers = await transferService.getTransferHistory(userId);

    return res.status(200).json(transfers.map(transferDTO));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  createTransfer,
  getHistory,
};
