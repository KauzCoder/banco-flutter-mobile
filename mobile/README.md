# Mobile - Quantum Bank

Aplicativo Flutter do Quantum Bank.

## Organizacao principal

- `lib/main.dart`: entrada do app.
- `lib/app.dart`: widget raiz e rotas principais.
- `lib/core`: tema, constantes, rotas e configuracoes globais.
- `lib/models`: modelos usados pelo app.
- `lib/services`: chamadas HTTP, APIs externas e plugins.
- `lib/controllers`: estado e regras de tela.
- `lib/screens`: telas do aplicativo.
- `lib/widgets`: componentes reutilizaveis.
- `assets/images`: imagens do app.
- `assets/svgs`: icones SVG usados nas telas.

## Instalar dependencias

```powershell
flutter pub get
```

## Rodar no Android

Antes de abrir o app, deixe o backend rodando em `backend` com:

```powershell
npm run start
```

Android Emulator:

```powershell
flutter run -d emulator-5554
```

Por padrao, o app usa a API hospedada:

```text
https://banco-flutter-mobile.onrender.com
```

O valor de `BACKEND_BASE_URL` sobrescreve o padrao definido em
`lib/core/api_constants.dart`.

Para usar backend local no Android Emulator:

```powershell
flutter run -d emulator-5554 --dart-define=BACKEND_BASE_URL=http://10.0.2.2:3000
```

## Gerar APK

APK unico:

```powershell
flutter build apk --release
```

Saida:

```text
build/app/outputs/flutter-apk/app-release.apk
```

APKs separados por arquitetura:

```powershell
flutter build apk --split-per-abi
```

Saidas:

```text
build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
build/app/outputs/flutter-apk/app-x86_64-release.apk
```

## Comandos de verificacao

```powershell
flutter analyze
flutter test
```

## Observacoes

- Para testar login, transferencia, saldo e cartoes, o backend precisa estar ativo.
- Para receber dados reais, rode o seed do backend antes do teste inicial.
- Em APK instalado no celular fisico, `localhost` nao aponta para o computador.
