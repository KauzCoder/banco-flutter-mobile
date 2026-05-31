# Arquitetura do Quantum Bank

O projeto usa uma arquitetura monolitica no backend e uma separacao em camadas
no app Flutter. A divisao geral segue uma ideia de MVC adaptada:

- Model: modelos de dados no Flutter e documentos do Firestore.
- View: telas e widgets Flutter.
- Controller: controllers Flutter e controllers HTTP do Express.
- Service: regras de negocio e integracao com APIs.
- Repository: acesso direto ao Firestore no backend.

> Status: incompleto. A arquitetura ja suporta o fluxo principal de login,
> home, transferencia e comprovante, mas ainda faltam testes, hospedagem da API
> e finalizacao de recursos secundarios.

## MVC monolitico

```mermaid
flowchart TB
    subgraph Mobile["Flutter App"]
        View["Views\nscreens/widgets"]
        MobileController["Controllers\nprofile, quotes, transfer, transactions"]
        MobileService["Services\nHTTP, storage local, plugins"]
        MobileModel["Models\nUserProfile, Transaction, CreditCard, Quote"]
    end

    subgraph Backend["API monolitica Express"]
        Route["Routes"]
        Controller["HTTP Controllers"]
        Service["Services\nregras de negocio"]
        Repository["Repositories\nFirestore access"]
        Validation["Validations\nZod schemas"]
    end

    subgraph Firebase["Firebase"]
        Auth["Firebase Auth"]
        Firestore["Firestore Collections"]
    end

    View --> MobileController
    MobileController --> MobileService
    MobileController --> MobileModel
    MobileService --> Route
    Route --> Validation
    Route --> Controller
    Controller --> Service
    Service --> Repository
    Service --> Auth
    Repository --> Firestore
```

## Diagrama de classes

```mermaid
classDiagram
    class UserProfile {
        +String id
        +String nome
        +String email
        +String? telefone
        +String? cpf
    }

    class UserSettings {
        +String id
        +String userId
        +bool notificacoesAtivas
        +bool biometriaAtiva
        +bool temaEscuro
        +String idioma
    }

    class CreditCardModel {
        +String id
        +String userId
        +String accountId
        +String apelido
        +String bandeira
        +String ultimosDigitos
        +String tipo
        +double limite
        +bool ativo
    }

    class TransactionModel {
        +String id
        +String fromUserId
        +String contaOrigemId
        +String contaDestinoId
        +String nomeRecebedor
        +String chavePixRecebedor
        +String tipo
        +String status
        +double valor
        +DateTime dataHora
    }

    class QuoteModel {
        +String code
        +String name
        +double bid
        +double pctChange
    }

    class TransferContact {
        +String name
        +String key
        +String? accountNumber
    }

    class TransferRequest {
        +String recipient
        +double amount
        +String? description
        +String? cardId
        +String type
    }

    class AuthService {
        +login(email, password)
        +register(data)
        +refreshToken()
        +getSavedUser()
    }

    class TransferService {
        +transfer(request)
    }

    class CardService {
        +getCards()
    }

    class TransactionsService {
        +getHistory()
    }

    class QuotesService {
        +getQuotes()
    }

    UserProfile "1" --> "1" UserSettings
    UserProfile "1" --> "*" CreditCardModel
    UserProfile "1" --> "*" TransactionModel
    TransferRequest --> TransferContact
    TransferService --> TransferRequest
    CardService --> CreditCardModel
    TransactionsService --> TransactionModel
    QuotesService --> QuoteModel
    AuthService --> UserProfile
```

## Collections do Firestore

```mermaid
erDiagram
    USERS ||--|| ACCOUNTS : owns
    USERS ||--o{ CARDS : owns
    USERS ||--o{ PIX_KEYS : owns
    USERS ||--|| USER_SETTINGS : has
    ACCOUNTS ||--o{ TRANSACTIONS : sends
    ACCOUNTS ||--o{ TRANSACTIONS : receives

    USERS {
        string id
        string nome
        string email
        string telefone
        string cpf
    }

    ACCOUNTS {
        string id
        string userId
        string agencia
        string numeroConta
        number saldo
        string status
    }

    CARDS {
        string id
        string userId
        string accountId
        string apelido
        string bandeira
        string ultimosDigitos
        number limite
    }

    PIX_KEYS {
        string id
        string userId
        string accountId
        string tipo
        string valor
        boolean ativa
    }

    TRANSACTIONS {
        string id
        string fromUserId
        string contaOrigemId
        string contaDestinoId
        string nomeRecebedor
        number valor
        string status
    }
```

## Fluxo de transferencia

```mermaid
sequenceDiagram
    participant U as Usuario
    participant V as TransferScreen
    participant C as TransferController
    participant S as TransferService Mobile
    participant API as API Express
    participant B as TransferService Backend
    participant DB as Firestore
    participant R as ReceiptScreen

    U->>V: informa destinatario e valor
    V->>C: valida campos locais
    C->>S: envia TransferRequest
    S->>API: POST /transfers
    API->>B: valida regra de negocio
    B->>DB: busca origem, destino e saldo
    B->>DB: debita origem, credita destino e salva transacao
    API-->>S: retorna transferencia concluida
    S-->>C: dados do comprovante
    C-->>R: navega com argumentos
```

## Observacoes tecnicas

- O backend e monolitico porque rotas, controllers, services e repositories
  ficam em uma unica aplicacao Express.
- O app Flutter nao acessa o Firestore diretamente; ele conversa com a API.
- O token do Firebase Auth e enviado no header `Authorization`.
- O comprovante usa plugin para capturar a tela e compartilhar o arquivo.
