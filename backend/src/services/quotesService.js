function buildQuote(symbol, name, price, change, category) {
  return {
    symbol,
    name,
    price,
    change,
    changePositive: change.startsWith('+'),
    category,
  };
}

exports.getQuotes = () => {
  const quotes = [
    buildQuote('USD', 'Dólar Americano', '5.31', '+0,86%', 'Moedas'),
    buildQuote('EUR', 'Euro', '5.20', '+0,72%', 'Moedas'),
    buildQuote('JPY', 'Iene', '0.039', '+0,36%', 'Moedas'),
    buildQuote('BTC', 'Bitcoin', '132400.00', '+2,90%', 'Criptomoedas'),
    buildQuote('KZ', 'Kwanza', '2.30', '+0,78%', 'Moedas'),
  ];

  return quotes;
};
