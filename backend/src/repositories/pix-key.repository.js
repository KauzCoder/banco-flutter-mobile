const { db } = require('../config/firebase');

const collection = db.collection('pixKeys');

async function createPixKey(pixKeyData) {
  const docRef = collection.doc();

  await docRef.set({
    pixKeyId: docRef.id,
    accountId: pixKeyData.accountId || '',
    userId: pixKeyData.userId || '',
    tipo: pixKeyData.tipo || '',
    valor: pixKeyData.valor || '',
    ativa: pixKeyData.ativa ?? true,
    dataCriacao: new Date(),
  });

  return findPixKeyById(docRef.id);
}

async function findPixKeyById(id) {
  const doc = await collection.doc(id).get();

  if (!doc.exists) {
    return null;
  }

  return {
    id: doc.id,
    ...doc.data(),
  };
}

async function findPixKeysByUserId(userId) {
  const snapshot = await collection.where('userId', '==', userId).get();

  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
}

module.exports = {
  createPixKey,
  findPixKeyById,
  findPixKeysByUserId,
};
