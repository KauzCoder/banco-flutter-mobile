# Backend - Banco Digital

Pasta reservada para a API Node.js + Express.

## Organizacao planejada

- `src/server.js`: entrada do servidor.
- `src/app.js`: configuracao do Express.
- `src/config`: Firebase e variaveis de ambiente.
- `src/routes`: endpoints da API.
- `src/controllers`: entrada das requisicoes.
- `src/services`: regras de negocio.
- `src/repositories`: acesso ao Firestore.
- `src/middlewares`: autenticacao, validacao e erros.
- `src/utils`: funcoes auxiliares.

## Endpoints planejados

- `POST /auth/register`
- `POST /auth/login`
- `GET /auth/me`
- `GET /account/balance`
- `GET /account/summary`
- `GET /quotes`
- `POST /transfers`
- `GET /transfers/history`

## Padronizacao de campos (API e Firestore)

A API aceita alguns aliases de entrada (ex.: pt-BR e en), mas **salva e responde**
sempre em um **padrao unico** (pt-BR). O objetivo e evitar documentos com campos
duplicados e manter as respostas previsiveis.

### Padrao de campos por entidade

**Usuario**
- `id`
- `nome`
- `email`
- `telefone`
- `fotoPerfil`
- `cpf`
- `dataCriacao`

**Conta**
- `id`
- `userId`
- `agencia`
- `numeroConta`
- `saldo`
- `status`
- `tipoConta`
- `dataCriacao`

**Chave Pix**
- `id`
- `userId`
- `accountId`
- `tipo`
- `valor`
- `ativa`
- `dataCriacao`

**Configuracoes do usuario**
- `id`
- `userId`
- `biometriaAtiva`
- `idioma`
- `notificacoesAtivas`
- `temaEscuro`

**Transferencia**
- `id`
- `fromUserId`
- `contaOrigemId`
- `contaDestinoId`
- `nomeRecebedor`
- `chavePixRecebedor`
- `descricao`
- `status`
- `tipo`
- `valor`
- `dataHora`

### Aliases aceitos na entrada

Os services normalizam os dados antes de validar e salvar. Exemplos:
- `name` -> `nome`
- `password` ou `senha` -> `password`
- `amount` -> `valor`
- `description` -> `descricao`
- `toAccountId` -> `contaDestinoId`
- `type` -> `tipo`
- `value` -> `valor`

## DTOs (resposta padronizada)

Os controllers usam DTOs para sempre responder no formato padronizado. Isso evita
expor campos internos e garante consistencia.

### Exemplo: resposta de Pix Key

```json
{
	"id": "pixKeyId",
	"userId": "userId",
	"accountId": "accountId",
	"tipo": "email",
	"valor": "ana.lima@example.com",
	"ativa": true,
	"dataCriacao": "2026-05-28T00:00:00.000Z"
}
```

### Exemplo: resposta de transferencia

```json
{
	"id": "transactionId",
	"fromUserId": "userId",
	"contaOrigemId": "accountIdOrigem",
	"contaDestinoId": "accountIdDestino",
	"nomeRecebedor": "Bruno Costa",
	"chavePixRecebedor": "+55 11 99999-0002",
	"descricao": "Pagamento de almoco",
	"status": "concluida",
	"tipo": "pix",
	"valor": 42.9,
	"dataHora": "2026-05-28T00:00:00.000Z"
}
```
