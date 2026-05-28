const accountRepository = require('../repositories/account.repository');
const userSettingsRepository = require('../repositories/user-settings.repository');
const userRepository = require('../repositories/user.repository');

function normalizeRegisterInput(data) {
  return {
    nome: data.nome || data.name || '',
    email: data.email || '',
    password: data.password || data.senha || '',
    cpf: data.cpf || null,
  };
}

function normalizeLoginInput(data) {
  return {
    email: data.email || '',
    password: data.password || data.senha || '',
  };
}

function removePassword(user) {
  const { password, ...userWithoutPassword } = user;

  return userWithoutPassword;
}

async function registerUser(data) {
  const { nome, email, password, cpf } = normalizeRegisterInput(data);

  if (!nome || !email || !password) {
    const error = new Error('Nome, email e senha sao obrigatorios.');
    error.statusCode = 400;
    throw error;
  }

  const existingUser = await userRepository.findUserByEmail(email);

  if (existingUser) {
    const error = new Error('Email ja cadastrado.');
    error.statusCode = 409;
    throw error;
  }

  const user = await userRepository.createUser({
    nome,
    email,
    password,
    cpf: cpf || null,
  });

  const account = await accountRepository.createAccount({
    userId: user.id,
  });
  const settings = await userSettingsRepository.createUserSettings(user.id);

  return {
    user: removePassword(user),
    account,
    settings,
  };
}

async function loginUser(data) {
  const { email, password } = normalizeLoginInput(data);

  if (!email || !password) {
    const error = new Error('Email e senha sao obrigatorios.');
    error.statusCode = 400;
    throw error;
  }

  const user = await userRepository.findUserByEmail(email);

  if (!user || user.password !== password) {
    const error = new Error('Email ou senha invalidos.');
    error.statusCode = 401;
    throw error;
  }

  return {
    user: removePassword(user),
  };
}

async function getCurrentUser(userId) {
  if (!userId) {
    const error = new Error('Informe o userId.');
    error.statusCode = 400;
    throw error;
  }

  const user = await userRepository.findUserById(userId);

  if (!user) {
    const error = new Error('Usuario nao encontrado.');
    error.statusCode = 404;
    throw error;
  }

  return removePassword(user);
}

module.exports = {
  getCurrentUser,
  loginUser,
  registerUser,
};
