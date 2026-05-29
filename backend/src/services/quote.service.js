async function getQuotes() {
  return [
    {
      code: 'USD',
      name: 'Dolar',
      value: 5.15,
    },
    {
      code: 'EUR',
      name: 'Euro',
      value: 5.58,
    },
    {
      code: 'BTC',
      name: 'Bitcoin',
      value: 350000,
    },
  ];
}

module.exports = {
  getQuotes,
};
