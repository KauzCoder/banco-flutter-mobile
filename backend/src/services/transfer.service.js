const accountRepository = require("../repositories/account.repository");
const pixKeyRepository = require("../repositories/pix-key.repository");
const transferRepository = require("../repositories/transfer.repository");
const userRepository = require("../repositories/user.repository");

function normalizeTransferInput(data) {
  return {
    fromUserId: data.fromUserId || data.userId || null,
    contaDestinoId: data.contaDestinoId || data.toAccountId || null,
    valor: Number(data.valor ?? data.amount ?? 0),
    descricao: data.descricao ?? data.description ?? data.message ?? "",
    recipient: data.recipient || null,
    nomeRecebedor: data.nomeRecebedor || "",
    chavePixRecebedor: data.chavePixRecebedor || "",
    cardId: data.cardId || "",
    tipo: data.tipo || data.type || "transferencia",
  };
}

async function resolveDestinationAccount(input) {
  if (input.contaDestinoId) {
    const account = await accountRepository.findAccountById(input.contaDestinoId);
    return { account, receiverName: input.nomeRecebedor, pixKey: input.chavePixRecebedor };
  }

  const recipient = String(
    input.chavePixRecebedor || input.recipient || input.nomeRecebedor || "",
  ).trim();

  if (!recipient) {
    return { account: null, receiverName: "", pixKey: "" };
  }

  const pixKey = await pixKeyRepository.findPixKeyByValue(recipient);
  if (pixKey) {
    const account = await accountRepository.findAccountById(pixKey.accountId);
    const user = account ? await userRepository.findUserById(account.userId) : null;
    return {
      account,
      receiverName: user?.nome || input.nomeRecebedor || recipient,
      pixKey: pixKey.valor,
    };
  }

  const byEmail = await userRepository.findUserByEmail(recipient);
  if (byEmail) {
    const account = await accountRepository.findAccountByUserId(byEmail.id);
    return {
      account,
      receiverName: byEmail.nome || recipient,
      pixKey: recipient,
    };
  }

  const byName = await userRepository.findUserByName(recipient);
  if (byName) {
    const account = await accountRepository.findAccountByUserId(byName.id);
    return {
      account,
      receiverName: byName.nome || recipient,
      pixKey: input.chavePixRecebedor || "",
    };
  }

  const digits = recipient.replace(/\D/g, "");
  if (digits) {
    const account = await accountRepository.findAccountByNumber(digits);
    if (account) {
      const user = await userRepository.findUserById(account.userId);
      return {
        account,
        receiverName: user?.nome || recipient,
        pixKey: input.chavePixRecebedor || "",
      };
    }
  }

  return { account: null, receiverName: input.nomeRecebedor || recipient, pixKey: input.chavePixRecebedor || recipient };
}

async function createTransfer(data) {
  const input = normalizeTransferInput(data);
  const numericAmount = input.valor;

  if (!input.fromUserId || !numericAmount) {
    const error = new Error(
      "fromUserId, destinatario e valor sao obrigatorios.",
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
  const destination = await resolveDestinationAccount(input);
  const toAccount = destination.account;

  if (!fromAccount) {
    const error = new Error("Conta de origem nao encontrada.");
    error.statusCode = 404;
    throw error;
  }

  if (!toAccount) {
    const error = new Error("Destinatario nao encontrado.");
    error.statusCode = 404;
    throw error;
  }

  if (fromAccount.id === toAccount.id) {
    const error = new Error("Nao e possivel transferir para sua propria conta.");
    error.statusCode = 400;
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
    toAccountId: toAccount.id,
    contaOrigemId: fromAccount.id,
    contaDestinoId: toAccount.id,
    valor: numericAmount,
    descricao: input.descricao,
    nomeRecebedor: destination.receiverName,
    chavePixRecebedor: destination.pixKey,
    cardId: input.cardId,
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
