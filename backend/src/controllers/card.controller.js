const cardService = require("../services/card.service");

function cardDTO(card) {
  return {
    id: card.id || card.cardId,
    userId: card.userId || "",
    holderName: card.holderName || "",
    brand: card.brand || "",
    last4: card.last4 || "",
    type: card.type || "credit",
    limit: Number(card.limit || 0),
    availableLimit: Number(card.availableLimit || 0),
    active: card.active ?? true,
  };
}

async function getCards(req, res, next) {
  try {
    const cards = await cardService.getUserCards(req.userId);
    return res.status(200).json(cards.map(cardDTO));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  getCards,
};
