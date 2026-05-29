const { z } = require("zod");

const amountSchema = z.coerce
  .number({ message: "Valor da transferencia deve ser numerico." })
  .positive("Valor da transferencia deve ser maior que zero.");

const transferBodySchema = z
  .object({
    contaDestinoId: z.string().trim().min(1, "Conta de destino e obrigatoria.").optional(),
    toAccountId: z.string().trim().min(1, "Conta de destino e obrigatoria.").optional(),
    valor: amountSchema.optional(),
    amount: amountSchema.optional(),
    descricao: z.string().trim().optional(),
    description: z.string().trim().optional(),
    nomeRecebedor: z.string().trim().optional(),
    chavePixRecebedor: z.string().trim().optional(),
    tipo: z.string().trim().min(1).optional(),
    fromUserId: z.string().trim().min(1).optional(),
  })
  .superRefine((data, ctx) => {
    if (!data.contaDestinoId && !data.toAccountId) {
      ctx.addIssue({
        code: "custom",
        path: ["contaDestinoId"],
        message: "Conta de destino e obrigatoria.",
      });
    }

    if (data.valor === undefined && data.amount === undefined) {
      ctx.addIssue({
        code: "custom",
        path: ["valor"],
        message: "Valor da transferencia e obrigatorio.",
      });
    }
  });

module.exports = {
  createTransferSchema: z.object({ body: transferBodySchema }),
};
