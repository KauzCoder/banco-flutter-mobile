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
