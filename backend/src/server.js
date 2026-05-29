const express = require('express');
const cors = require('cors');
const routes = require('./routes');

const app = express();
const port = process.env.PORT || 3333;

app.use(cors());
app.use(express.json());
app.use('/api', routes);

app.use((req, res) => {
  res.status(404).json({ error: 'Endpoint não encontrado' });
});

app.listen(port, () => {
  console.log(`Backend rodando em http://localhost:${port}/api`);
});
