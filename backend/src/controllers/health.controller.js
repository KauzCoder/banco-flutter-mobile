const healthService = require('../services/health.service');

async function getHealth(req, res, next) {
  try {
    const health = await healthService.getHealthStatus();

    return res.status(200).json(health);
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  getHealth,
};
