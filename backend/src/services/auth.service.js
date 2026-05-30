const https = require("https");
const accountRepository = require("../repositories/account.repository");
const userSettingsRepository = require("../repositories/user-settings.repository");
const userRepository = require("../repositories/user.repository");
const { admin } = require("../config/firebase");

function normalizeRegisterInput(data) {
  return {
    nome: data.nome || data.name || "",
    email: data.email || "",
    password: data.password || data.senha || "",
    cpf: data.cpf || null,
  };
}

function normalizeLoginInput(data) {
  return {
    email: data.email || "",
    password: data.password || data.senha || "",
  };
}

function requireFirebaseApiKey() {
  if (!process.env.FIREBASE_API_KEY) {
    const error = new Error("FIREBASE_API_KEY nao configurado no .env.");
    error.statusCode = 500;
    throw error;
  }

  return process.env.FIREBASE_API_KEY;
}

function firebaseAuthRequest(endpoint, payload) {
  const apiKey = requireFirebaseApiKey();
  const data = JSON.stringify(payload);

  return new Promise((resolve, reject) => {
    const request = https.request(
      {
        hostname: "identitytoolkit.googleapis.com",
        path: `/v1/${endpoint}?key=${apiKey}`,
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Content-Length": Buffer.byteLength(data),
        },
      },
      (response) => {
        let body = "";

        response.on("data", (chunk) => {
          body += chunk;
        });

        response.on("end", () => {
          let parsed = {};

          try {
            parsed = body ? JSON.parse(body) : {};
          } catch (parseError) {
            const error = new Error("Resposta invalida do Firebase Auth.");
            error.statusCode = 500;
            return reject(error);
          }

          if (response.statusCode >= 400) {
            const error = new Error(
              parsed.error?.message || "Erro no Firebase Auth.",
            );
            error.statusCode = 401;
            return reject(error);
          }

          return resolve(parsed);
        });
      },
    );

    request.on("error", (requestError) => {
      const error = new Error(
        requestError.message || "Erro ao chamar Firebase Auth.",
      );
      error.statusCode = 500;
      reject(error);
    });

    request.write(data);
    request.end();
  });
}

function firebaseSecureTokenRequest(payload) {
  const apiKey = requireFirebaseApiKey();
  const data = JSON.stringify(payload);

  return new Promise((resolve, reject) => {
    const request = https.request(
      {
        hostname: "securetoken.googleapis.com",
        path: `/v1/token?key=${apiKey}`,
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Content-Length": Buffer.byteLength(data),
        },
      },
      (response) => {
        let body = "";

        response.on("data", (chunk) => {
          body += chunk;
        });

        response.on("end", () => {
          let parsed = {};

          try {
            parsed = body ? JSON.parse(body) : {};
          } catch (parseError) {
            const error = new Error("Resposta invalida do Firebase Auth.");
            error.statusCode = 500;
            return reject(error);
          }

          if (response.statusCode >= 400) {
            const error = new Error(
              parsed.error?.message || "Erro no Firebase Auth.",
            );
            error.statusCode = 401;
            return reject(error);
          }

          return resolve(parsed);
        });
      },
    );

    request.on("error", (requestError) => {
      const error = new Error(
        requestError.message || "Erro ao chamar Firebase Auth.",
      );
      error.statusCode = 500;
      reject(error);
    });

    request.write(data);
    request.end();
  });
}

async function signInWithPassword(email, password) {
  return firebaseAuthRequest("accounts:signInWithPassword", {
    email,
    password,
    returnSecureToken: true,
  });
}

async function refreshIdToken(refreshToken) {
  return firebaseSecureTokenRequest({
    grant_type: "refresh_token",
    refresh_token: refreshToken,
  });
}

function removePassword(user) {
  const { password, ...userWithoutPassword } = user;

  return userWithoutPassword;
}

async function registerUser(data) {
  const { nome, email, password, cpf } = normalizeRegisterInput(data);

  if (!nome || !email || !password) {
    const error = new Error("Nome, email e senha sao obrigatorios.");
    error.statusCode = 400;
    throw error;
  }

  let firebaseUser;

  try {
    firebaseUser = await admin.auth().createUser({
      email,
      password,
      displayName: nome,
    });
  } catch (error) {
    if (error.code === "auth/email-already-exists") {
      const conflict = new Error("Email ja cadastrado.");
      conflict.statusCode = 409;
      throw conflict;
    }

    const failure = new Error("Erro ao criar usuario no Firebase Auth.");
    failure.statusCode = 500;
    throw failure;
  }

  const user = await userRepository.createUser({
    userId: firebaseUser.uid,
    nome,
    email,
    cpf: cpf || null,
  });

  const account = await accountRepository.createAccount({
    userId: user.id,
  });
  const settings = await userSettingsRepository.createUserSettings(user.id);

  const authResult = await signInWithPassword(email, password);

  return {
    user: removePassword(user),
    account,
    settings,
    token: authResult.idToken,
    refreshToken: authResult.refreshToken,
    expiresIn: Number(authResult.expiresIn || 0),
  };
}

async function loginUser(data) {
  const { email, password } = normalizeLoginInput(data);

  if (!email || !password) {
    const error = new Error("Email e senha sao obrigatorios.");
    error.statusCode = 400;
    throw error;
  }

  let authResult;

  try {
    authResult = await signInWithPassword(email, password);
  } catch (error) {
    const authError = new Error("Email ou senha invalidos.");
    authError.statusCode = 401;
    throw authError;
  }

  const firebaseUserId = authResult.localId;
  let user = await userRepository.findUserById(firebaseUserId);

  if (!user) {
    const firebaseUser = await admin.auth().getUser(firebaseUserId);
    user = await userRepository.createUser({
      userId: firebaseUserId,
      nome: firebaseUser.displayName || "",
      email: firebaseUser.email || email,
    });
  }

  return {
    user: removePassword(user),
    token: authResult.idToken,
    refreshToken: authResult.refreshToken,
    expiresIn: Number(authResult.expiresIn || 0),
  };
}

async function getCurrentUser(userId) {
  if (!userId) {
    const error = new Error("Informe o userId.");
    error.statusCode = 400;
    throw error;
  }

  const user = await userRepository.findUserById(userId);

  if (!user) {
    const error = new Error("Usuario nao encontrado.");
    error.statusCode = 404;
    throw error;
  }

  return removePassword(user);
}

async function refreshToken(data) {
  const refreshTokenValue = data.refreshToken || data.refresh_token || "";

  if (!refreshTokenValue) {
    const error = new Error("refreshToken e obrigatorio.");
    error.statusCode = 400;
    throw error;
  }

  let refreshResult;

  try {
    refreshResult = await refreshIdToken(refreshTokenValue);
  } catch (error) {
    const authError = new Error("Refresh token invalido.");
    authError.statusCode = 401;
    throw authError;
  }

  return {
    token: refreshResult.id_token,
    refreshToken: refreshResult.refresh_token,
    expiresIn: Number(refreshResult.expires_in || 0),
  };
}

module.exports = {
  getCurrentUser,
  loginUser,
  refreshToken,
  registerUser,
};
