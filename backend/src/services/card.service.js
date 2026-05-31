const cardRepository = require("../repositories/card.repository");

async function getUserCards(userId) {
  if (!userId) {
    const error = new Error("Usuario nao autenticado.");
    error.statusCode = 401;
    throw error;
  }

  return cardRepository.findCardsByUserId(userId);
}

module.exports = {
  getUserCards,
};
