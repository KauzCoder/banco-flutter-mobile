const { db } = require('../config/firebase');

const collection = db.collection('userSettings');

async function createUserSettings(userId, settingsData = {}) {
  const docRef = collection.doc();

  await docRef.set({
    userId,
    biometriaAtiva: settingsData.biometriaAtiva ?? false,
    idioma: settingsData.idioma || 'pt-BR',
    notificacoesAtivas: settingsData.notificacoesAtivas ?? true,
    temaEscuro: settingsData.temaEscuro ?? false,
  });

  return findUserSettingsByUserId(userId);
}

async function findUserSettingsByUserId(userId) {
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

async function updateUserSettings(userId, settingsData) {
  const settings = await findUserSettingsByUserId(userId);

  if (!settings) {
    return createUserSettings(userId, settingsData);
  }

  await collection.doc(settings.id).update(settingsData);

  return findUserSettingsByUserId(userId);
}

module.exports = {
  createUserSettings,
  findUserSettingsByUserId,
  updateUserSettings,
};
