# 🎯 Mapa de Telas - Banco Flutter Mobile

## 📱 Fluxo Completo da Aplicação

```
┌─────────────────────────────────────────────────────────────┐
│                    🔐 LOGIN SCREEN                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Email/Telefone: ________________                     │   │
│  │ Senha: ________________                              │   │
│  │ [Esqueceu a senha?]                                 │   │
│  │ ┌──────────────────────────────────────────────┐   │   │
│  │ │         [Entrar]                             │   │   │
│  │ └──────────────────────────────────────────────┘   │   │
│  │ Não tem conta? [Criar agora]                       │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                         ↓
        ┌────────────────────────────────────┐
        │   ✅ Login Bem-sucedido            │
        └────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│             🏠 HOME SCREEN / DASHBOARD                      │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Bem-vindo, Ling!         🔔 (Notificações)         │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │ ┌────────────────────────────────────────────────┐ │   │
│  │ │ Saldo Disponível: R$ 50.540,00       👁️       │ │   │
│  │ └────────────────────────────────────────────────┘ │   │
│  │                                                     │   │
│  │ Ações Rápidas:                                     │   │
│  │ 🔄 [Enviar] 💰 [Receber] 📱 [QR Code]            │   │
│  │ 📈 [Investir] 💳 [Cartão]                        │   │
│  │                                                     │   │
│  │ Cotações:                                          │   │
│  │ USD: R$ 5,25 ↑ 0,85%  | EUR: R$ 5,85 ↓ 0,32%   │   │
│  │                                                     │   │
│  │ Últimas Transações: [Ver todas →]                │   │
│  │ ↗️ Transferência: -R$ 250  | ↙️ Salário: +R$ 3.5K │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
         ↙️      ↓       ↓        ↓         ↓         ↘️
        /        |       |        |         |          \
    [Cotações] [Transfer] [PIX] [Perfil] [Config] [Payments]
       ↓          ↓        ↓       ↓        ↓          ↓

┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│💱 COTAÇÕES   │ │💸 TRANSFER   │ │🏧 PIX AREA   │ │👤 PERFIL     │
├──────────────┤ ├──────────────┤ ├──────────────┤ ├──────────────┤
│ USD  5,25    │ │Tipo:         │ │Chaves PIX:   │ │Ling Habei    │
│ EUR  5,85    │ │• Bancária    │ │✓ Email       │ │✓ Verificado  │
│ GBP  6,50    │ │• PIX         │ │✓ Telefone    │ │              │
│ JPY  0,045   │ │• TED         │ │✓ CPF         │ │Menu:         │
│ AUD  3,50    │ │              │ │✓ Aleatória   │ │✏️ Editar     │
│ CAD  3,92    │ │CPF/CNPJ:     │ │              │ │🔑 Senha      │
│              │ │__________    │ │[Meu QR]      │ │🌐 Idioma     │
│              │ │Valor:        │ │[Escanear]    │ │🔒 Segurança  │
│              │ │R$ __,__      │ │[Transfer]    │ │🚪 Sair       │
│              │ │Desc: _______ │ │              │ │              │
│              │ │Taxa: Grátis  │ │Ult. Trans:   │ │              │
│              │ │              │ │↗️ PIX Enviado│ │              │
│              │ │[Confirmar]   │ │↙️ PIX Receb. │ │              │
└──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘
                         ↓                 ↓
                    ┌─────────┐       ┌──────────┐
                    │📄 RECIBO │       │📱 MEU QR │
                    ├─────────┤       ├──────────┤
                    │ ✅ Sucesso      │QR Code   │
                    │Tipo: Transf.    │[Display] │
                    │Valor: R$ 250    │          │
                    │Benef: Ling      │Nome      │
                    │CPF: 123...      │Email     │
                    │Data: 25/05      │Telefone  │
                    │Hora: 14:30      │CPF       │
                    │ID: #TRX123456   │          │
                    │Status: OK ✓     │[Compartilhar]
                    │Saldo: R$ 50.2K  │[Baixar]  │
                    │                 │          │
                    │[Compartilhar]   │          │
                    │[Home]           │[Home]    │
                    └─────────────────┴──────────┘

┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│⚙️ CONFIG     │ │🔑 SENHA      │ │🌐 IDIOMA     │ │💳 PAGAMENTOS │
├──────────────┤ ├──────────────┤ ├──────────────┤ ├──────────────┤
│Notificações  │ │Senha Atual:  │ │🇧🇷 Português │ │Total Mês:    │
│ ✓ Ativas     │ │________      │ │🇺🇸 English   │ │R$ 122,98     │
│              │ │Nova Senha:   │ │🇪🇸 Español   │ │              │
│Biometria     │ │________      │ │🇫🇷 Français  │ │Apple Store:  │
│ ✓ Ativa      │ │              │ │🇩🇪 Deutsch   │ │-R$ 9,99      │
│              │ │Confirmar:    │ │🇨🇳 中文      │ │Spotify:      │
│Modo Escuro   │ │________      │ │🇯🇵 日本語    │ │-R$ 12,99     │
│ ✓ Ativo      │ │              │ │🇰🇷 한국어    │ │PIX: -R$ 100  │
│              │ │Min. 8 caract │ │              │ │              │
│[Privacidade] │ │              │ │[Selecionar]  │ │[Detalhes]    │
│[Termos]      │ │[Alterar]     │ │              │ │[Compartilhar]│
│[Ajuda]       │ │              │ │              │ │              │
│v 1.0.0       │ │              │ │              │ │              │
└──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘

┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│🏧 SCAN QR   │ │📊 HISTÓRICO  │ │⏳ LOADING    │
├──────────────┤ ├──────────────┤ ├──────────────┤
│Câmera Ativa  │ │Filtros:      │ │   ⏳         │
│              │ │[Todas]       │ │Processando...│
│  ┌────────┐  │ │[Enviadas]    │ │Por favor,    │
│  │ QR □   │  │ │[Recebidas]   │ │aguarde       │
│  └────────┘  │ │[Pagamentos]  │ │              │
│              │ │              │ │              │
│🔦 Flash: ON  │ │Transações:   │ │              │
│              │ │↗️ -R$ 250    │ │              │
│[Processar]   │ │↙️ +R$ 3.5K   │ │              │
│              │ │↗️ -R$ 850    │ │              │
└──────────────┘ └──────────────┘ └──────────────┘

┌─────────────────────────────────────────────────────────────┐
│             ✅ FEEDBACK SCREEN                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                     │   │
│  │         Tipo: SUCESSO ✓ | ERRO ✗                  │   │
│  │                                                     │   │
│  │                   ⭕ ou ❌                          │   │
│  │                                                     │   │
│  │         Título da Ação                             │   │
│  │         Mensagem descritiva                        │   │
│  │                                                     │   │
│  │    [Tentar Novamente] | [Voltar para Home]       │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## 📌 Legenda

```
🔐 = Autenticação
🏠 = Principal
💱 = Cotações
💸 = Transferências
📄 = Comprovante
📊 = Histórico
🏧 = PIX
👤 = Perfil
⚙️ = Configurações
💳 = Pagamentos
⏳ = Loading
✅ = Feedback
```

## 🔀 Fluxos Principais

### Fluxo 1: Transferência Bancária
```
HOME → TRANSFER → Preencher dados → RECEIPT → HOME/PAYMENT
```

### Fluxo 2: PIX
```
HOME → PIX AREA → [SCAN QR / MEU QR / TRANSFERÊNCIA] → TRANSFER → RECEIPT
```

### Fluxo 3: Consultas
```
HOME → [COTAÇÕES / HISTÓRICO / PAGAMENTOS]
```

### Fluxo 4: Configurações
```
PROFILE → [SETTINGS / SENHA / IDIOMA / SAIR]
```

## 🎨 Paleta de Cores

```
🟣 Roxo (Primário)      #7C3AED    - Botões, Links, Headers
🟡 Amarelo (Secundário) #FEE82C    - Ações Rápidas, Destaque
🔵 Azul (Destaque)      #3B82F6    - Informações, Links Alt
✅ Verde (Sucesso)      #10B981    - Confirmações, OK
❌ Vermelho (Erro)      #EF4444    - Erros, Avisos
⚠️ Laranja (Aviso)      #F59E0B    - Alertas
⚫ Preto (Fundo)        #1F1F1F    - Background
⚪ Branco (Texto)       #FFFFFF    - Texto Principal
```

## 📐 Componentes Utilizados

```
✓ BalanceCard         - Exibição de saldo
✓ QuickActionButton   - Botões rápidos
✓ TransactionListItem - Item de transação
✓ CustomButton        - Botão personalizado
✓ ScreenHeader        - Header padrão
✓ TextField           - Entrada de dados
✓ Container           - Cards e seções
✓ ListView            - Listas scrolláveis
✓ GridView            - Grid de ações
✓ Dialog              - Confirmações
✓ Switch              - Toggles
✓ DropdownButton      - Seleção
```

---

**Criado em:** Maio 2024
**Status:** ✅ Completo
**Próxima Etapa:** Integração com Backend
