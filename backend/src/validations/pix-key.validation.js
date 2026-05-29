const { z } = require("zod");

const pixKeyBodySchema = z
  .object({
    tipo: z.string().trim().min(1, "Tipo da chave Pix e obrigatorio.").optional(),
    type: z.string().trim().min(1, "Tipo da chave Pix e obrigatorio.").optional(),
    valor: z.string().trim().min(1, "Valor da chave Pix e obrigatorio.").optional(),
    value: z.string().trim().min(1, "Valor da chave Pix e obrigatorio.").optional(),
    ativa: z.boolean().optional(),
    userId: z.string().trim().min(1).optional(),
  })
  .superRefine((data, ctx) => {
    if (!data.tipo && !data.type) {
      ctx.addIssue({
        code: "custom",
        path: ["tipo"],
        message: "Tipo da chave Pix e obrigatorio.",
      });
    }

    if (!data.valor && !data.value) {
      ctx.addIssue({
        code: "custom",
        path: ["valor"],
        message: "Valor da chave Pix e obrigatorio.",
      });
    }
  });

module.exports = {
  createPixKeySchema: z.object({ body: pixKeyBodySchema }),
};
