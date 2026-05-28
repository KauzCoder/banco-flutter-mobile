const { db } = require('../config/firebase');

const collection = db.collection('accounts');

async function createAccount(accountData) {
  const docRef = collection.doc();

  await docRef.set({
    accountId: docRef.id,
    agencia: accountData.agencia || '0001',
    numeroConta: accountData.numeroConta || String(Date.now()).slice(-8),
    saldo: Number(accountData.saldo || 0),
    status: accountData.status || 'ativa',
    tipoConta: accountData.tipoConta || 'corrente',
    userId: accountData.userId || '',
    dataCriacao: new Date(),
  });

  return findAccountById(docRef.id);
}

async function findAccountById(id) {
  const doc = await collection.doc(id).get();

  if (!doc.exists) {
    return null;
  }

  return {
    id: doc.id,
    ...doc.data(),
  };
}

async function findAccountByUserId(userId) {
  const snapshot = await collection.where('userId', '==', userId).limit(1).get();

  if (snapshot.empty) {
    return null;
  }

  const doc = snapshot.docs[0];

  return {
    id: doc.id,
    ...doc.data(),
  };
}

async function updateBalance(accountId, saldo) {
  await collection.doc(accountId).update({
    saldo,
    dataAtualizacao: new Date(),
  });

  return findAccountById(accountId);
}

module.exports = {
  createAccount,
  findAccountById,
  findAccountByUserId,
  updateBalance,
};
