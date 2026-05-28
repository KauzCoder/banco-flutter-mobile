const accountRepository = require('../repositories/account.repository');
const pixKeyRepository = require('../repositories/pix-key.repository');

async function createPixKey(data) {
  const { userId, tipo, valor } = data;

  if (!userId || !tipo || !valor) {
    const error = new Error('userId, tipo e valor sao obrigatorios.');
    error.statusCode = 400;
    throw error;
  }

  const account = await accountRepository.findAccountByUserId(userId);

  if (!account) {
    const error = new Error('Conta nao encontrada.');
    error.statusCode = 404;
    throw error;
  }

  return pixKeyRepository.createPixKey({
    accountId: account.id,
    userId,
    tipo,
    valor,
    ativa: data.ativa,
  });
}

async function getPixKeys(userId) {
  if (!userId) {
    const error = new Error('Informe o userId.');
    error.statusCode = 400;
    throw error;
  }

  return pixKeyRepository.findPixKeysByUserId(userId);
}

module.exports = {
  createPixKey,
  getPixKeys,
};
