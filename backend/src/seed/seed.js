const { db } = require("../config/firebase");
const { admin } = require("../config/firebase");

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

  const userA = await upsertSeedUser({
    nome: "Ana Lima",
    email: "ana.lima@example.com",
    password: "123456",
    telefone: "+55 11 99999-0001",
    cpf: "111.222.333-44",
    fotoPerfil: "https://i.pravatar.cc/150?img=47",
    saldo: 2500.75,
    tipoConta: "corrente",
    settings: {
      biometriaAtiva: true,
      idioma: "pt-BR",
      notificacoesAtivas: true,
      temaEscuro: false,
    },
  });

  const userB = await upsertSeedUser({
    nome: "Bruno Costa",
    email: "bruno.costa@example.com",
    password: "123456",
    telefone: "+55 11 99999-0002",
    cpf: "555.666.777-88",
    fotoPerfil: "https://i.pravatar.cc/150?img=32",
    saldo: 180.25,
    tipoConta: "poupanca",
    settings: {
      biometriaAtiva: false,
      idioma: "pt-BR",
      notificacoesAtivas: true,
      temaEscuro: true,
    },
  });

  const transfer1 = await upsertTransaction("seed-transfer-ana-bruno", {
    fromUserId: userA.user.id,
    contaOrigemId: userA.account.id,
    contaDestinoId: userB.account.id,
    nomeRecebedor: userB.user.nome,
    chavePixRecebedor: userB.pixKey.valor,
    descricao: "Pagamento de almoco",
    valor: 42.9,
    status: "concluida",
    tipo: "pix",
  });

  const transfer2 = await upsertTransaction("seed-transfer-bruno-ana", {
    fromUserId: userB.user.id,
    contaOrigemId: userB.account.id,
    contaDestinoId: userA.account.id,
    nomeRecebedor: userA.user.nome,
    chavePixRecebedor: userA.pixKey.valor,
    descricao: "Reembolso",
    valor: 20.0,
    status: "concluida",
    tipo: "pix",
  });

  console.log("Seed concluido:", {
    users: [userA.user.id, userB.user.id],
    accounts: [userA.account.id, userB.account.id],
    pixKeys: [userA.pixKey.id, userB.pixKey.id],
    userSettings: [userA.settings.id, userB.settings.id],
    transfers: [transfer1.id, transfer2.id],
    loginTeste: [
      { email: userA.user.email, password: "123456" },
      { email: userB.user.email, password: "123456" },
    ],
  });
}

async function upsertFirebaseUser({ email, password, nome }) {
  try {
    const existingUser = await admin.auth().getUserByEmail(email);
    await admin.auth().updateUser(existingUser.uid, {
      displayName: nome,
      password,
    });
    return existingUser.uid;
  } catch (error) {
    if (error.code !== "auth/user-not-found") {
      throw error;
    }

    const firebaseUser = await admin.auth().createUser({
      email,
      password,
      displayName: nome,
    });
    return firebaseUser.uid;
  }
}

async function setDoc(collectionName, docId, data) {
  const docRef = db.collection(collectionName).doc(docId);
  await docRef.set(data, { merge: true });
  const doc = await docRef.get();

  return {
    id: doc.id,
    ...doc.data(),
  };
}

async function upsertSeedUser(seedUser) {
  const userId = await upsertFirebaseUser(seedUser);
  const accountId = `account_${userId}`;
  const pixKeyId = `pix_email_${userId}`;
  const settingsId = `settings_${userId}`;

  const user = await setDoc("users", userId, {
    userId,
    nome: seedUser.nome,
    email: seedUser.email,
    telefone: seedUser.telefone,
    fotoPerfil: seedUser.fotoPerfil,
    cpf: seedUser.cpf,
    dataCriacao: new Date(),
  });

  const account = await setDoc("accounts", accountId, {
    accountId,
    agencia: "0001",
    numeroConta: userId.slice(-8).padStart(8, "0"),
    saldo: seedUser.saldo,
    status: "ativa",
    tipoConta: seedUser.tipoConta,
    userId,
    dataCriacao: new Date(),
  });

  const pixKey = await setDoc("pixKeys", pixKeyId, {
    pixKeyId,
    userId,
    accountId,
    tipo: "email",
    valor: seedUser.email,
    ativa: true,
    dataCriacao: new Date(),
  });

  const settings = await setDoc("userSettings", settingsId, {
    userId,
    ...seedUser.settings,
  });

  return { user, account, pixKey, settings };
}

async function upsertTransaction(transactionId, transferData) {
  return setDoc("transactions", transactionId, {
    transactionId,
    fromUserId: transferData.fromUserId,
    chavePixRecebedor: transferData.chavePixRecebedor,
    contaDestinoId: transferData.contaDestinoId,
    contaOrigemId: transferData.contaOrigemId,
    descricao: transferData.descricao,
    nomeRecebedor: transferData.nomeRecebedor,
    status: transferData.status,
    tipo: transferData.tipo,
    valor: transferData.valor,
    dataHora: new Date(),
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
