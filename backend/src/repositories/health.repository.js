const { admin, db } = require('../config/firebase');

async function getFirebaseHealth() {
  await db.collection('_health').limit(1).get();

  return {
    connected: admin.apps.length > 0,
    projectId: db._settings.projectId,
  };
}

module.exports = {
  getFirebaseHealth,
};
