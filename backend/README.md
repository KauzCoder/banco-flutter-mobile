# Backend - Quantum Bank

API Node.js + Express do Quantum Bank, integrada ao Firebase Auth e Firestore.

## Organizacao

- `src/server.js`: entrada do servidor.
- `src/app.js`: configuracao do Express e rotas.
- `src/config`: Firebase e variaveis de ambiente.
- `src/routes`: endpoints da API.
- `src/controllers`: entrada das requisicoes.
- `src/services`: regras de negocio.
- `src/repositories`: acesso ao Firestore.
- `src/middlewares`: autenticacao, validacao e erros.
- `src/validations`: schemas de entrada.
- `src/seed/seed.js`: populacao inicial do Firestore.

## Instalar

```powershell
npm install
```

## Variaveis e credenciais

Crie `backend/.env`:

```env
FIREBASE_API_KEY=SUA_CHAVE_WEB_DO_FIREBASE
PORT=3000
```

Coloque a credencial do Firebase Admin em:

```text
backend/firebase-service-account.json
```

Se quiser usar outro caminho:

```powershell
$env:FIREBASE_SERVICE_ACCOUNT_PATH="C:\caminho\firebase-service-account.json"
```

Tambem e possivel usar `GOOGLE_APPLICATION_CREDENTIALS`.

## Rodar

```powershell
npm run start
```

Health check:

```powershell
npm run test:health
```

Teste de conexao com Firebase:

```powershell
npm run test:firebase
```

## Popular o banco

Para recriar os dados de teste:

```powershell
$env:SEED_CLEAR="true"; npm run seed:firebase
```

O seed cria usuarios, contas, chaves Pix, configuracoes, cartoes e transacoes
iniciais para testar o app.

## Endpoints principais

- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/refresh`
- `GET /auth/me`
- `GET /account/balance`
- `GET /account/summary`
- `GET /cards`
- `GET /quotes`
- `POST /transfers`
- `GET /transfers/history`
- `GET /user-settings`
- `PUT /user-settings`
- `GET /health`

## Autenticacao

Todas as rotas sao protegidas por Firebase Auth, exceto:

- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/refresh`
- `GET /health`

As rotas de login e cadastro retornam:

- `token`: ID Token JWT.
- `refreshToken`: token usado para renovar sessao.
- `expiresIn`: tempo de expiracao em segundos.

Envie o token nas rotas protegidas:

```text
Authorization: Bearer SEU_ID_TOKEN
```

## Refresh token

```http
POST /auth/refresh
Content-Type: application/json

{
  "refreshToken": "SEU_REFRESH_TOKEN"
}
```

## Padrao das collections

Collections usadas no Firestore:

- `users`
- `accounts`
- `pixKeys`
- `userSettings`
- `cards`
- `transactions`

Campos principais:

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

**Cartao**

- `id`
- `userId`
- `accountId`
- `apelido`
- `bandeira`
- `ultimosDigitos`
- `tipo`
- `ativo`
- `limite`
- `dataCriacao`

**Transferencia**

- `id`
- `fromUserId`
- `contaOrigemId`
- `contaDestinoId`
- `cardId`
- `nomeRecebedor`
- `chavePixRecebedor`
- `descricao`
- `status`
- `tipo`
- `valor`
- `dataHora`
