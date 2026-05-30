const accountRepository = require("../repositories/account.repository");
const transferRepository = require("../repositories/transfer.repository");

function normalizeTransferInput(data) {
  return {
    fromUserId: data.fromUserId || data.userId || null,
    contaDestinoId: data.contaDestinoId || data.toAccountId || null,
    valor: Number(data.valor ?? data.amount ?? 0),
    descricao: data.descricao ?? data.description ?? "",
    nomeRecebedor: data.nomeRecebedor || "",
    chavePixRecebedor: data.chavePixRecebedor || "",
    tipo: data.tipo || "transferencia",
  };
}

async function createTransfer(data) {
  const input = normalizeTransferInput(data);
  const destinationAccountId = input.contaDestinoId;
  const numericAmount = input.valor;

  if (!input.fromUserId || !destinationAccountId || !numericAmount) {
    const error = new Error(
      "fromUserId, contaDestinoId e valor sao obrigatorios.",
    );
    error.statusCode = 400;
    throw error;
  }

  if (numericAmount <= 0) {
    const error = new Error(
      "O valor da transferencia deve ser maior que zero.",
    );
    error.statusCode = 400;
    throw error;
  }

  const fromAccount = await accountRepository.findAccountByUserId(
    input.fromUserId,
  );
  const toAccount =
    await accountRepository.findAccountById(destinationAccountId);

  if (!fromAccount) {
    const error = new Error("Conta de origem nao encontrada.");
    error.statusCode = 404;
    throw error;
  }

  if (!toAccount) {
    const error = new Error("Conta de destino nao encontrada.");
    error.statusCode = 404;
    throw error;
  }

  if ((fromAccount.saldo || 0) < numericAmount) {
    const error = new Error("Saldo insuficiente.");
    error.statusCode = 400;
    throw error;
  }

  await accountRepository.updateBalance(
    fromAccount.id,
    (fromAccount.saldo || 0) - numericAmount,
  );
  await accountRepository.updateBalance(
    toAccount.id,
    (toAccount.saldo || 0) + numericAmount,
  );

  return transferRepository.createTransfer({
    fromUserId: input.fromUserId,
    fromAccountId: fromAccount.id,
    toAccountId: destinationAccountId,
    contaOrigemId: fromAccount.id,
    contaDestinoId: destinationAccountId,
    valor: numericAmount,
    descricao: input.descricao,
    nomeRecebedor: input.nomeRecebedor,
    chavePixRecebedor: input.chavePixRecebedor,
    status: "concluida",
    tipo: input.tipo,
  });
}

async function getTransferHistory(userId) {
  if (!userId) {
    const error = new Error("Informe o userId.");
    error.statusCode = 400;
    throw error;
  }

  return transferRepository.findTransfersByUserId(userId);
}

module.exports = {
  createTransfer,
  getTransferHistory,
};
