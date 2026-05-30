const healthRepository = require('../repositories/health.repository');

async function getHealthStatus() {
  const firebase = await healthRepository.getFirebaseHealth();

  return {
    status: 'ok',
    firebase: firebase.connected ? 'connected' : 'not_initialized',
    projectId: firebase.projectId,
  };
}

module.exports = {
  getHealthStatus,
};
