# Documentacao do Quantum Bank

Esta pasta concentra a documentacao usada para apresentacao do repositorio e
para explicar como o projeto foi organizado.

> Status: o projeto esta incompleto. A base principal esta implementada, mas
> ainda falta hospedagem definitiva da API, APK final validado, recursos de QR
> Code/recuperacao de senha e uma rodada completa de testes.

## Arquivos

- `TELAS.md`: mapa das telas, fluxo de navegacao e resumo por tela.
- `ARQUITETURA.md`: arquitetura monolitica MVC, diagrama de classes e fluxo de
  dados.
- `Plano_Banco_Digital_Kaua.pdf`: plano original do grupo.

## Design

O design do aplicativo foi feito no Figma. A implementacao Flutter busca seguir
o prototipo visual com tema escuro, cards roxos, destaques amarelo-lima,
icones SVG e telas inspiradas em aplicativo bancario mobile.

## Resumo do projeto

Quantum Bank e composto por:

- App Flutter em `mobile/`.
- API Express em `backend/`.
- Firebase Auth para autenticacao.
- Firestore para usuarios, contas, chaves Pix, cartoes e transacoes.
- Plugins mobile para compartilhamento de comprovante e armazenamento local.

## Checklist de entrega

- [x] Login com e-mail e senha conectado ao backend.
- [x] Home mostrando saldo e dados reais da conta.
- [x] Tela de cotacao com moedas atualizadas.
- [x] Tela de transferencia integrada ao backend.
- [x] Saldo validado antes da transferencia.
- [x] Saldo atualizado apos transferencia.
- [x] Historico de transacoes salvo.
- [x] Rotas nomeadas funcionando.
- [x] Rota com argumentos para comprovante.
- [x] Plugin extra funcionando: `screenshot`, `share_plus`, `path_provider`.
- [x] Banco de dados conectado ao Firebase/Firestore.
- [x] Codigo organizado em models, services, controllers, screens e widgets.
- [x] README atualizado.
- [ ] API hospedada em URL definitiva.
- [ ] APK final gerado com a URL hospedada.
- [ ] Teste manual final em Android.
- [ ] QR Code real e recuperacao de senha finalizados.

## Comandos finais recomendados

Backend:

```powershell
cd backend
$env:SEED_CLEAR="true"; npm run seed:firebase
npm run start
```

Mobile:

```powershell
cd mobile
flutter analyze
flutter build apk --release --dart-define=BACKEND_BASE_URL=https://banco-flutter-mobile.onrender.com
```
