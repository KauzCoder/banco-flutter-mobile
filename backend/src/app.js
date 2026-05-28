const cors = require('cors');
const express = require('express');
const accountRoutes = require('./routes/account.routes');
const authRoutes = require('./routes/auth.routes');
const healthRoutes = require('./routes/health.routes');
const pixKeyRoutes = require('./routes/pix-key.routes');
const quoteRoutes = require('./routes/quote.routes');
const transferRoutes = require('./routes/transfer.routes');
const userSettingsRoutes = require('./routes/user-settings.routes');

const app = express();

app.use(cors());
app.use(express.json());
app.use(healthRoutes);
app.use(authRoutes);
app.use(accountRoutes);
app.use(quoteRoutes);
app.use(transferRoutes);
app.use(pixKeyRoutes);
app.use(userSettingsRoutes);

app.use((error, req, res, next) => {
  return res.status(error.statusCode || 500).json({
    status: 'error',
    message: error.message,
  });
});

module.exports = app;
