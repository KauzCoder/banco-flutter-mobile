const accountRepository = require('../repositories/account.repository');

async function getAccountByUserId(userId) {
  if (!userId) {
    const error = new Error('Informe o userId.');
    error.statusCode = 400;
    throw error;
  }

  const account = await accountRepository.findAccountByUserId(userId);

  if (!account) {
    const error = new Error('Conta nao encontrada.');
    error.statusCode = 404;
    throw error;
  }

  return account;
}

async function getBalance(userId) {
  const account = await getAccountByUserId(userId);

  return {
    saldo: account.saldo || 0,
    moeda: 'BRL',
  };
}

async function getSummary(userId) {
  const account = await getAccountByUserId(userId);

  return {
    account,
  };
}

module.exports = {
  getAccountByUserId,
  getBalance,
  getSummary,
};
