const transferService = require('../services/transferService');

exports.createTransfer = (req, res) => {
  const { recipient, amount, message, type } = req.body;

  if (!recipient || !amount) {
    return res.status(400).json({ error: 'Destinatário e valor são obrigatórios' });
  }

  try {
    const transfer = transferService.createTransfer({ recipient, amount, message, type });
    res.status(201).json({ success: true, transfer });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Falha ao processar transferência' });
  }
};
