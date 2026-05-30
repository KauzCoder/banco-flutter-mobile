const quotesService = require('../services/quotesService');

exports.getQuotes = (req, res) => {
  try {
    const quotes = quotesService.getQuotes();
    res.json(quotes);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Falha ao carregar cotações' });
  }
};
