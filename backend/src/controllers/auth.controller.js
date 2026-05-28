const authService = require('../services/auth.service');

async function register(req, res, next) {
  try {
    const result = await authService.registerUser(req.body);

    return res.status(201).json(result);
  } catch (error) {
    return next(error);
  }
}

async function login(req, res, next) {
  try {
    const result = await authService.loginUser(req.body);

    return res.status(200).json(result);
  } catch (error) {
    return next(error);
  }
}

async function me(req, res, next) {
  try {
    const userId = req.headers['x-user-id'] || req.query.userId;
    const user = await authService.getCurrentUser(userId);

    return res.status(200).json(user);
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  login,
  me,
  register,
};
