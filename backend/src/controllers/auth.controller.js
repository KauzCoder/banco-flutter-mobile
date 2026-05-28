const authService = require("../services/auth.service");

function userDTO(user) {
  if (!user) {
    return null;
  }

  return {
    id: user.id || user.userId,
    nome: user.nome || "",
    email: user.email || "",
    telefone: user.telefone || "",
    fotoPerfil: user.fotoPerfil || "",
    cpf: user.cpf || null,
    dataCriacao: user.dataCriacao || null,
  };
}

function accountDTO(account) {
  if (!account) {
    return null;
  }

  return {
    id: account.id || account.accountId,
    userId: account.userId || "",
    agencia: account.agencia || "",
    numeroConta: account.numeroConta || "",
    saldo: Number(account.saldo || 0),
    status: account.status || "",
    tipoConta: account.tipoConta || "",
    dataCriacao: account.dataCriacao || null,
  };
}

function userSettingsDTO(settings) {
  if (!settings) {
    return null;
  }

  return {
    id: settings.id || settings.userSettingsId,
    userId: settings.userId || "",
    biometriaAtiva: settings.biometriaAtiva ?? false,
    idioma: settings.idioma || "pt-BR",
    notificacoesAtivas: settings.notificacoesAtivas ?? true,
    temaEscuro: settings.temaEscuro ?? false,
  };
}

async function register(req, res, next) {
  try {
    const result = await authService.registerUser(req.body);

    return res.status(201).json({
      user: userDTO(result.user),
      account: accountDTO(result.account),
      settings: userSettingsDTO(result.settings),
      token: result.token,
      refreshToken: result.refreshToken,
      expiresIn: result.expiresIn,
    });
  } catch (error) {
    return next(error);
  }
}

async function login(req, res, next) {
  try {
    const result = await authService.loginUser(req.body);

    return res.status(200).json({
      user: userDTO(result.user),
      token: result.token,
      refreshToken: result.refreshToken,
      expiresIn: result.expiresIn,
    });
  } catch (error) {
    return next(error);
  }
}

async function refresh(req, res, next) {
  try {
    const result = await authService.refreshToken(req.body);

    return res.status(200).json({
      token: result.token,
      refreshToken: result.refreshToken,
      expiresIn: result.expiresIn,
    });
  } catch (error) {
    return next(error);
  }
}

async function me(req, res, next) {
  try {
    const userId = req.userId || req.headers["x-user-id"] || req.query.userId;
    const user = await authService.getCurrentUser(userId);

    return res.status(200).json(userDTO(user));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  login,
  me,
  refresh,
  register,
};
