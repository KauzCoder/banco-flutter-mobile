const accountService = require("../services/account.service");

function accountDTO(account) {
  if (!account) {
    return null;
  }

  return {
    id: account.id || account.accountId,
    userId: account.userId || "",
    agencia: account.agencia || "",
    numeroConta: account.numeroConta || "",
    saldo: Number(account.saldo || 0),
    status: account.status || "",
    tipoConta: account.tipoConta || "",
    dataCriacao: account.dataCriacao || null,
  };
}

async function getBalance(req, res, next) {
  try {
    const userId = req.userId || req.headers["x-user-id"] || req.query.userId;
    const balance = await accountService.getBalance(userId);

    return res.status(200).json(balance);
  } catch (error) {
    return next(error);
  }
}

async function getSummary(req, res, next) {
  try {
    const userId = req.userId || req.headers["x-user-id"] || req.query.userId;
    const summary = await accountService.getSummary(userId);

    return res.status(200).json({
      ...summary,
      account: accountDTO(summary.account),
    });
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  getBalance,
  getSummary,
};
