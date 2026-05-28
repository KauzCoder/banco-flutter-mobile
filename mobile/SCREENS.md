# 📱 Banco Flutter Mobile - Documentação de Telas

## ✨ Telas Implementadas

### 🔐 Autenticação
- **Login Screen** (`auth/login_screen.dart`)
  - Login com email/telefone e senha
  - Recuperação de senha
  - Criar nova conta

### 🏠 Principal
- **Home Screen** (`home/home_screen.dart`)
  - Cartão de saldo com toggle de visibilidade
  - Menu rápido com 5 ações (Enviar, Receber, QR Code, Investir, Cartão)
  - Cotações de moedas
  - Últimas transações

### 💱 Cotações
- **Quotes Screen** (`quotes/quotes_screen.dart`)
  - Lista de cotações de moedas
  - Preço em tempo real
  - Variação percentual

### 💸 Transferências
- **Transfer Screen** (`transfer/transfer_screen.dart`)
  - Seleção de tipo (Transferência Bancária, PIX, TED)
  - Inserção de dados do beneficiário
  - Valor e descrição
  - Informação de taxa

### 📄 Comprovante
- **Receipt Screen** (`receipt/receipt_screen.dart`)
  - Confirmação de sucesso
  - Detalhes da transação
  - Saldo atualizado
  - Compartilhamento de comprovante

### 📊 Histórico de Transações
- **Transactions History Screen** (`transactions/transactions_history_screen.dart`)
  - Filtros (Todas, Enviadas, Recebidas, Pagamentos)
  - Lista de transações com ícones coloridos
  - Detalhes de data e valor

### 🏧 PIX
- **PIX Area Screen** (`pix/pix_area_screen.dart`)
  - Minhas chaves PIX (Email, Telefone, CPF, Aleatória)
  - Ações rápidas (Meu QR Code, Escanear, Transferência)
  - Últimas transações PIX

- **Scan QR Screen** (`pix/scan_qr_screen.dart`)
  - Scanner de QR Code
  - Flash light ativável
  - Detecção automática de QR

- **My QR Code Screen** (`pix/my_qr_code_screen.dart`)
  - Exibição do QR Code pessoal
  - Informações da conta
  - Compartilhamento e download

### 👤 Perfil
- **Profile Screen** (`profile/profile_screen.dart`)
  - Foto e informações do usuário
  - Dados pessoais
  - Status de verificação
  - Menu de ações (Alterar Dados, Senha, Idioma, Segurança, Sair)

### ⚙️ Configurações
- **Settings Screen** (`settings/settings_screen.dart`)
  - Notificações
  - Autenticação biométrica
  - Modo escuro
  - Links de privacidade
  - Suporte

- **Change Password Screen** (`settings/change_password_screen.dart`)
  - Validação de senha atual
  - Nova senha com confirmação
  - Requisitos de segurança

- **Language Screen** (`settings/language_screen.dart`)
  - Seleção de idiomas (8 opções)
  - Bandeiras dos países
  - Mudança instantânea

### 💳 Pagamentos
- **Payments Screen** (`account/payments_screen.dart`)
  - Resumo de pagamentos do mês
  - Histórico de transações
  - Informações de cada pagamento

### ⏳ Carregamento
- **Loading Screen** (`loading_screen.dart`)
  - Indicador de carregamento animado
  - Mensagem customizável
  - "Por favor, aguarde"

### ✅ Feedback
- **Feedback Screen** (`feedback_screen.dart`)
  - Tipos: Sucesso, Erro, Aviso, Info
  - Ícones e cores personalizadas
  - Dicas contextuais
  - Botões de ação customizáveis

- **Error Screen** (variante)
  - Tela especializada para erros
  - Botão de retry e voltar para home

- **Success Screen** (variante)
  - Tela especializada para sucesso
  - Confirmação com botão de continuar

## 🎨 Componentes Reutilizáveis

### common_widgets.dart
- `BalanceCard` - Cartão de saldo com toggle de visibilidade
- `QuickActionButton` - Botão de ação rápida
- `TransactionListItem` - Item da lista de transações
- `CustomButton` - Botão customizado com estados
- `ScreenHeader` - Header padrão de tela

## 🎯 Cores e Tema

**Theme Principal**
- Cor primária: `#7C3AED` (Roxo)
- Cor secundária: `#FEE82C` (Amarelo)
- Cor destaque: `#3B82F6` (Azul)
- Fundo escuro: `#1F1F1F`

## 📂 Estrutura de Pastas

```
screens/
├── auth/
│   └── login_screen.dart
├── home/
│   └── home_screen.dart
├── quotes/
│   └── quotes_screen.dart
├── transfer/
│   └── transfer_screen.dart
├── receipt/
│   └── receipt_screen.dart
├── transactions/
│   └── transactions_history_screen.dart
├── pix/
│   ├── pix_area_screen.dart
│   ├── scan_qr_screen.dart
│   └── my_qr_code_screen.dart
├── profile/
│   └── profile_screen.dart
├── settings/
│   ├── settings_screen.dart
│   ├── change_password_screen.dart
│   └── language_screen.dart
├── account/
│   └── payments_screen.dart
├── loading_screen.dart
└── feedback_screen.dart

widgets/
└── common_widgets.dart

core/
├── theme.dart
└── constants.dart
```

## 🔗 Rotas de Navegação

```dart
/login - Tela de Login
/home - Tela Principal
/quotes - Cotação de Moedas
/transfer - Transferência
/receipt - Comprovante
/transactions-history - Histórico de Transações
/pix-area - Área PIX
/scan-qr - Scanner QR
/my-qr-code - Meu QR Code
/profile - Perfil
/settings - Configurações
/change-password - Alterar Senha
/language - Idioma
/payments - Pagamentos
/loading - Tela de Carregamento
/feedback - Feedback
/error - Tela de Erro
```

## 🚀 Como Usar

1. Importe o arquivo de rotas:
```dart
import 'core/routes/app_routes.dart';
```

2. Configure as rotas no MaterialApp:
```dart
MaterialApp(
  routes: AppRoutes.routes,
  initialRoute: AppRoutes.login,
  theme: AppTheme.darkTheme(),
)
```

3. Navegue entre telas:
```dart
Navigator.pushNamed(context, AppRoutes.home);
Navigator.pop(context);
```

## 📝 Notas

- Todas as telas seguem o design das imagens fornecidas
- Componentes são reutilizáveis e customizáveis
- Cores seguem a paleta de cores do projeto
- Animações suaves com duração padrão de 300ms
- Todos os elementos são responsivos

## 🔄 Próximas Etapas

- [ ] Integrar com API backend
- [ ] Implementar autenticação real
- [ ] Adicionar cache local
- [ ] Testes unitários
- [ ] Testes de interface
- [ ] Publicação na App Store/Google Play
