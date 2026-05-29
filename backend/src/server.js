const path = require("path");
const dotenv = require("dotenv");

dotenv.config();
dotenv.config({
  path: path.join(__dirname, "config", ".env"),
  override: false,
});

const app = require("./app");

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
