function formatPath(issue) {
  return issue.path.length ? issue.path.join(".") : "body";
}

function validateRequest(schema) {
  return (req, res, next) => {
    const result = schema.safeParse({
      body: req.body,
      query: req.query,
      params: req.params,
    });

    if (!result.success) {
      const error = new Error("Dados da requisicao invalidos.");
      error.statusCode = 400;
      error.details = result.error.issues.map((issue) => ({
        campo: formatPath(issue),
        mensagem: issue.message,
      }));

      return next(error);
    }

    req.body = result.data.body || req.body;
    req.query = result.data.query || req.query;
    req.params = result.data.params || req.params;

    return next();
  };
}

module.exports = validateRequest;
