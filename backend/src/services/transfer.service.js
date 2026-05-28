const accountRepository = require('../repositories/account.repository');
const transferRepository = require('../repositories/transfer.repository');

async function createTransfer(data) {
  const { fromUserId, toAccountId, contaDestinoId, amount, valor, description, descricao } = data;
  const destinationAccountId = toAccountId || contaDestinoId;
  const numericAmount = Number(amount || valor);

  if (!fromUserId || !destinationAccountId || !numericAmount) {
    const error = new Error('fromUserId, contaDestinoId e valor sao obrigatorios.');
    error.statusCode = 400;
    throw error;
  }

  if (numericAmount <= 0) {
    const error = new Error('O valor da transferencia deve ser maior que zero.');
    error.statusCode = 400;
    throw error;
  }

  const fromAccount = await accountRepository.findAccountByUserId(fromUserId);
  const toAccount = await accountRepository.findAccountById(destinationAccountId);

  if (!fromAccount) {
    const error = new Error('Conta de origem nao encontrada.');
    error.statusCode = 404;
    throw error;
  }

  if (!toAccount) {
    const error = new Error('Conta de destino nao encontrada.');
    error.statusCode = 404;
    throw error;
  }

  if ((fromAccount.saldo || 0) < numericAmount) {
    const error = new Error('Saldo insuficiente.');
    error.statusCode = 400;
    throw error;
  }

  await accountRepository.updateBalance(fromAccount.id, (fromAccount.saldo || 0) - numericAmount);
  await accountRepository.updateBalance(toAccount.id, (toAccount.saldo || 0) + numericAmount);

  return transferRepository.createTransfer({
    fromUserId,
    fromAccountId: fromAccount.id,
    toAccountId: destinationAccountId,
    contaOrigemId: fromAccount.id,
    contaDestinoId: destinationAccountId,
    amount: numericAmount,
    valor: numericAmount,
    description: description || descricao || null,
    descricao: descricao || description || '',
    status: 'concluida',
  });
}

async function getTransferHistory(userId) {
  if (!userId) {
    const error = new Error('Informe o userId.');
    error.statusCode = 400;
    throw error;
  }

  return transferRepository.findTransfersByUserId(userId);
}

module.exports = {
  createTransfer,
  getTransferHistory,
};
