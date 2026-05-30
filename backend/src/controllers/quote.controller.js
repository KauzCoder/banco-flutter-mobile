const quoteService = require('../services/quote.service');

async function getQuotes(req, res, next) {
  try {
    const quotes = await quoteService.getQuotes();

    return res.status(200).json(quotes);
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  getQuotes,
};
