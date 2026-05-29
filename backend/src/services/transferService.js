exports.createTransfer = ({ recipient, amount, message, type }) => {
  return {
    id: `trf_${Date.now()}`,
    recipient,
    amount,
    message: message ?? '',
    type: type ?? 'PIX',
    createdAt: new Date().toISOString(),
  };
};
