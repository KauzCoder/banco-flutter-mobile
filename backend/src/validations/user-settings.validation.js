const { z } = require("zod");

const userSettingsBodySchema = z
  .object({
    biometriaAtiva: z.boolean().optional(),
    idioma: z.string().trim().min(1, "Idioma nao pode ser vazio.").optional(),
    notificacoesAtivas: z.boolean().optional(),
    temaEscuro: z.boolean().optional(),
    userId: z.string().trim().min(1).optional(),
  })
  .refine((data) => Object.keys(data).length > 0, {
    message: "Informe pelo menos uma configuracao para atualizar.",
  });

module.exports = {
  updateUserSettingsSchema: z.object({ body: userSettingsBodySchema }),
};
