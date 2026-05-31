const fs = require("fs");
const path = require("path");
const admin = require("firebase-admin");
const dotenv = require("dotenv");

dotenv.config({ path: path.resolve(__dirname, ".env"), quiet: true });
dotenv.config({ path: path.resolve(__dirname, "../../.env"), quiet: true });

function resolveServiceAccountPath() {
  const candidates = [
    process.env.FIREBASE_SERVICE_ACCOUNT_PATH,
    process.env.GOOGLE_APPLICATION_CREDENTIALS,
    path.resolve(__dirname, "../../firebase-service-account.json"),
  ].filter(Boolean);

  const serviceAccountPath = candidates.find((candidate) =>
    fs.existsSync(path.resolve(candidate)),
  );

  if (!serviceAccountPath) {
    throw new Error(
      `Credencial do Firebase Admin nao encontrada. Caminhos procurados: ${candidates.join(", ")}`,
    );
  }

  return path.resolve(serviceAccountPath);
}

const serviceAccount = require(resolveServiceAccountPath());

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

const db = admin.firestore();

module.exports = {
  admin,
  db,
};
