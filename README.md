# Quantum Bank

Quantum Bank e um projeto academico de banco digital com app mobile em Flutter
e API monolitica em Node.js/Express conectada ao Firebase Auth e Firestore.

> Status: projeto incompleto. O app ja possui login, home, cotacoes,
> transferencia, comprovante e integracao parcial com backend, mas ainda faltam
> testes finais, hospedagem definitiva da API, ajustes de producao e validacao
> completa em Android.

## Design

O design visual do aplicativo foi criado no Figma. As telas Flutter seguem a
identidade proposta no prototipo: tema escuro, roxo como cor principal,
amarelo-lima para acoes e componentes com visual de banco digital.

## Tecnologias

- Flutter e Dart para o app mobile.
- Node.js e Express para a API.
- Firebase Authentication para login.
- Firestore como banco de dados.
- AwesomeAPI para cotacoes.
- Plugins Flutter: `share_plus`, `screenshot`, `path_provider`,
  `shared_preferences` e `flutter_svg`.

## Estrutura

```text
.
|-- backend/   API Express, services, repositories, seed e Firebase Admin
|-- mobile/    App Flutter, screens, controllers, services e models
|-- docs/      Documentacao de apresentacao, telas e arquitetura
```

## Funcionalidades implementadas

- Login e cadastro conectados ao backend.
- Persistencia do ultimo usuario logado para facilitar novo login.
- Home com saldo, dados do usuario, cotacoes e transacoes reais.
- Area Pix com atalhos e telas relacionadas.
- Transferencia entre usuarios cadastrados no banco.
- Validacao de saldo antes da transferencia.
- Cartoes carregados de acordo com o usuario.
- Comprovante com dados reais e compartilhamento via plugin.
- Tela de cotacoes com opcao de ver mais moedas.
- Tela generica para recursos ainda em desenvolvimento.

## Funcionalidades incompletas

- Alguns atalhos ainda levam para tela de recurso em desenvolvimento.
- QR Code real e leitura por camera ainda nao estao finalizados.
- Recuperacao de senha, notificacoes e biometria ainda precisam de conclusao.
- Ainda nao ha suite completa de testes automatizados.

## Documentacao

- [Documentacao geral](docs/README.md)
- [Mapa e resumo das telas](docs/TELAS.md)
- [Arquitetura, diagrama de classes e MVC](docs/ARQUITETURA.md)
- [README do backend](backend/README.md)
- [README do mobile](mobile/README.md)

## Rodar localmente

Backend:

```powershell
cd backend
npm install
$env:SEED_CLEAR="true"; npm run seed:firebase
npm run start
```

Mobile:

```powershell
cd mobile
flutter pub get
flutter run --dart-define=BACKEND_BASE_URL=http://SEU_IP_LOCAL:3000
```

No Android Emulator, use:

```powershell
flutter run -d emulator-5554 --dart-define=BACKEND_BASE_URL=http://10.0.2.2:3000
```

## Gerar APK

Depois de hospedar a API, gere o APK apontando para a URL publicada:

```powershell
cd mobile
flutter build apk --release --dart-define=BACKEND_BASE_URL=https://URL_DA_SUA_API
```

Saida:

```text
mobile/build/app/outputs/flutter-apk/app-release.apk
```

## Branches do grupo

- `main`: versao estavel.
- `backend-kaua`: backend, banco, API e revisao final.
- `frontend-maria`: login e home.
- `frontend-neto`: cotacao, transferencia, rotas e estado.
- `ui-jean`: componentes visuais, layout, README e prints.
- `plugin-rian`: share_plus, comprovante e testes.

Nada deve ir direto para `main` sem revisao.
