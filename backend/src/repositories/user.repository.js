const { db } = require('../config/firebase');

const collection = db.collection('users');

async function createUser(userData) {
  const docRef = collection.doc();

  await docRef.set({
    userId: docRef.id,
    nome: userData.nome || '',
    email: userData.email || '',
    telefone: userData.telefone || '',
    fotoPerfil: userData.fotoPerfil || '',
    password: userData.password || '',
    cpf: userData.cpf || null,
    dataCriacao: new Date(),
  });

  return findUserById(docRef.id);
}

async function findUserByEmail(email) {
  const snapshot = await collection.where('email', '==', email).limit(1).get();

  if (snapshot.empty) {
    return null;
  }

  const doc = snapshot.docs[0];

  return {
    id: doc.id,
    ...doc.data(),
  };
}

async function findUserById(id) {
  const doc = await collection.doc(id).get();

  if (!doc.exists) {
    return null;
  }

  return {
    id: doc.id,
    ...doc.data(),
  };
}

module.exports = {
  createUser,
  findUserByEmail,
  findUserById,
};
