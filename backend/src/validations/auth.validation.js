const { z } = require("zod");

const nameSchema = z.string().trim().min(1, "Nome e obrigatorio.");
const emailSchema = z.string().trim().email("Email invalido.");
const passwordSchema = z.string().min(6, "Senha deve ter pelo menos 6 caracteres.");

const registerBodySchema = z
  .object({
    nome: nameSchema.optional(),
    name: nameSchema.optional(),
    email: emailSchema,
    password: passwordSchema.optional(),
    senha: passwordSchema.optional(),
    cpf: z.string().trim().min(1).optional().nullable(),
  })
  .superRefine((data, ctx) => {
    if (!data.nome && !data.name) {
      ctx.addIssue({
        code: "custom",
        path: ["nome"],
        message: "Nome e obrigatorio.",
      });
    }

    if (!data.password && !data.senha) {
      ctx.addIssue({
        code: "custom",
        path: ["password"],
        message: "Senha e obrigatoria.",
      });
    }
  });

const loginBodySchema = z
  .object({
    email: emailSchema,
    password: passwordSchema.optional(),
    senha: passwordSchema.optional(),
  })
  .superRefine((data, ctx) => {
    if (!data.password && !data.senha) {
      ctx.addIssue({
        code: "custom",
        path: ["password"],
        message: "Senha e obrigatoria.",
      });
    }
  });

const refreshBodySchema = z
  .object({
    refreshToken: z.string().trim().min(1, "refreshToken e obrigatorio.").optional(),
    refresh_token: z.string().trim().min(1, "refreshToken e obrigatorio.").optional(),
  })
  .superRefine((data, ctx) => {
    if (!data.refreshToken && !data.refresh_token) {
      ctx.addIssue({
        code: "custom",
        path: ["refreshToken"],
        message: "refreshToken e obrigatorio.",
      });
    }
  });

module.exports = {
  loginSchema: z.object({ body: loginBodySchema }),
  refreshSchema: z.object({ body: refreshBodySchema }),
  registerSchema: z.object({ body: registerBodySchema }),
};
