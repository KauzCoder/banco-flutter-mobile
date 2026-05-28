const { admin } = require("../config/firebase");

async function firebaseAuthMiddleware(req, res, next) {
  try {
    const authHeader = req.headers.authorization || "";
    const bearerToken = authHeader.startsWith("Bearer ")
      ? authHeader.slice(7)
      : null;
    const token = bearerToken || req.headers["x-access-token"];

    if (!token) {
      const error = new Error("Token de autenticacao nao informado.");
      error.statusCode = 401;
      throw error;
    }

    const decoded = await admin.auth().verifyIdToken(token);

    req.user = decoded;
    req.userId = decoded.uid;
    req.headers["x-user-id"] = decoded.uid;

    return next();
  } catch (error) {
    const authError = new Error("Token invalido ou expirado.");
    authError.statusCode = 401;
    return next(authError);
  }
}

module.exports = firebaseAuthMiddleware;
