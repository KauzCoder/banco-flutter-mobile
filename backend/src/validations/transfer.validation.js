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
    message: z.string().trim().optional(),
    recipient: z.string().trim().min(1).optional(),
    nomeRecebedor: z.string().trim().optional(),
    chavePixRecebedor: z.string().trim().optional(),
    tipo: z.string().trim().min(1).optional(),
    type: z.string().trim().min(1).optional(),
    cardId: z.string().trim().min(1).optional(),
    fromUserId: z.string().trim().min(1).optional(),
  })
  .superRefine((data, ctx) => {
    if (
      !data.contaDestinoId &&
      !data.toAccountId &&
      !data.recipient &&
      !data.chavePixRecebedor &&
      !data.nomeRecebedor
    ) {
      ctx.addIssue({
        code: "custom",
        path: ["recipient"],
        message: "Destinatario e obrigatorio.",
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
