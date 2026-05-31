const { db } = require("../config/firebase");

const collection = db.collection("transactions");

async function createTransfer(transferData) {
  const docRef = collection.doc();

  await docRef.set({
    transactionId: docRef.id,
    fromUserId: transferData.fromUserId || "",
    chavePixRecebedor: transferData.chavePixRecebedor || "",
    contaDestinoId:
      transferData.contaDestinoId || transferData.toAccountId || "",
    contaOrigemId:
      transferData.contaOrigemId || transferData.fromAccountId || "",
    descricao: transferData.descricao || transferData.description || "",
    nomeRecebedor: transferData.nomeRecebedor || "",
    cardId: transferData.cardId || "",
    status: transferData.status || "concluida",
    tipo: transferData.tipo || "transferencia",
    valor: Number(transferData.valor || transferData.amount || 0),
    dataHora: new Date(),
  });

  return findTransferById(docRef.id);
}

async function findTransferById(id) {
  const doc = await collection.doc(id).get();

  if (!doc.exists) {
    return null;
  }

  return {
    id: doc.id,
    ...doc.data(),
  };
}

async function findTransfersByUserId(userId) {
  const snapshot = await collection.where("fromUserId", "==", userId).get();

  return snapshot.docs
    .map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }))
    .sort((a, b) => {
      const dateA = a.dataHora?.toDate ? a.dataHora.toDate() : new Date(0);
      const dateB = b.dataHora?.toDate ? b.dataHora.toDate() : new Date(0);

      return dateB - dateA;
    });
}

module.exports = {
  createTransfer,
  findTransfersByUserId,
};
