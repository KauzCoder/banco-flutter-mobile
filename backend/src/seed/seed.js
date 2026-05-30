const { db } = require("../config/firebase");
const { createUser } = require("../repositories/user.repository");
const { createAccount } = require("../repositories/account.repository");
const { createPixKey } = require("../repositories/pix-key.repository");
const { createTransfer } = require("../repositories/transfer.repository");
const {
  createUserSettings,
} = require("../repositories/user-settings.repository");

async function clearCollection(collectionName) {
  const snapshot = await db.collection(collectionName).get();

  if (snapshot.empty) {
    return 0;
  }

  const batch = db.batch();

  snapshot.docs.forEach((doc) => {
    batch.delete(doc.ref);
  });

  await batch.commit();

  return snapshot.size;
}

async function seed() {
  if (process.env.SEED_CLEAR === "true") {
    const deleted = await Promise.all([
      clearCollection("users"),
      clearCollection("accounts"),
      clearCollection("pixKeys"),
      clearCollection("transactions"),
      clearCollection("userSettings"),
    ]);

    console.log("Colecoes limpas:", {
      users: deleted[0],
      accounts: deleted[1],
      pixKeys: deleted[2],
      transactions: deleted[3],
      userSettings: deleted[4],
    });
  }

  const userA = await createUser({
    nome: "Ana Lima",
    email: "ana.lima@example.com",
    telefone: "+55 11 99999-0001",
    password: "123456",
    fotoPerfil: "https://i.pravatar.cc/150?img=47",
  });

  const userB = await createUser({
    nome: "Bruno Costa",
    email: "bruno.costa@example.com",
    telefone: "+55 11 99999-0002",
    password: "123456",
    fotoPerfil: "https://i.pravatar.cc/150?img=32",
  });

  const accountA = await createAccount({
    userId: userA.id,
    saldo: 2500.75,
    tipoConta: "corrente",
    status: "ativa",
  });

  const accountB = await createAccount({
    userId: userB.id,
    saldo: 180.25,
    tipoConta: "poupanca",
    status: "ativa",
  });

  const pixKeyA = await createPixKey({
    userId: userA.id,
    accountId: accountA.id,
    tipo: "email",
    valor: userA.email,
    ativa: true,
  });

  const pixKeyB = await createPixKey({
    userId: userB.id,
    accountId: accountB.id,
    tipo: "telefone",
    valor: userB.telefone,
    ativa: true,
  });

  const settingsA = await createUserSettings(userA.id, {
    biometriaAtiva: true,
    idioma: "pt-BR",
    notificacoesAtivas: true,
    temaEscuro: false,
  });

  const settingsB = await createUserSettings(userB.id, {
    biometriaAtiva: false,
    idioma: "pt-BR",
    notificacoesAtivas: true,
    temaEscuro: true,
  });

  const transfer1 = await createTransfer({
    fromUserId: userA.id,
    contaOrigemId: accountA.id,
    contaDestinoId: accountB.id,
    nomeRecebedor: userB.nome,
    chavePixRecebedor: pixKeyB.valor,
    descricao: "Pagamento de almoco",
    valor: 42.9,
    status: "concluida",
    tipo: "pix",
  });

  const transfer2 = await createTransfer({
    fromUserId: userB.id,
    contaOrigemId: accountB.id,
    contaDestinoId: accountA.id,
    nomeRecebedor: userA.nome,
    chavePixRecebedor: pixKeyA.valor,
    descricao: "Reembolso",
    valor: 20.0,
    status: "concluida",
    tipo: "pix",
  });

  console.log("Seed concluido:", {
    users: [userA.id, userB.id],
    accounts: [accountA.id, accountB.id],
    pixKeys: [pixKeyA.id, pixKeyB.id],
    userSettings: [settingsA.id, settingsB.id],
    transfers: [transfer1.id, transfer2.id],
  });
}

seed()
  .then(() => {
    console.log("Seed finalizado com sucesso.");
    process.exit(0);
  })
  .catch((error) => {
    console.error("Erro ao executar seed:", error);
    process.exit(1);
  });
