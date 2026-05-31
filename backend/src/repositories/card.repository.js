const { db } = require("../config/firebase");

const collection = db.collection("cards");

async function createCard(cardData) {
  const docRef = cardData.cardId ? collection.doc(cardData.cardId) : collection.doc();

  await docRef.set(
    {
      cardId: docRef.id,
      userId: cardData.userId || "",
      holderName: cardData.holderName || "",
      brand: cardData.brand || "Quantum",
      last4: cardData.last4 || "",
      type: cardData.type || "credit",
      limit: Number(cardData.limit || 0),
      availableLimit: Number(cardData.availableLimit ?? cardData.limit ?? 0),
      active: cardData.active ?? true,
      createdAt: cardData.createdAt || new Date(),
    },
    { merge: true },
  );

  return findCardById(docRef.id);
}

async function findCardById(id) {
  const doc = await collection.doc(id).get();

  if (!doc.exists) {
    return null;
  }

  return {
    id: doc.id,
    ...doc.data(),
  };
}

async function findCardsByUserId(userId) {
  const snapshot = await collection
    .where("userId", "==", userId)
    .where("active", "==", true)
    .get();

  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
}

module.exports = {
  createCard,
  findCardById,
  findCardsByUserId,
};
