# Shelf APIs 🚀

API RESTful modular desenvolvida em **Dart** com o framework **Shelf**, voltada para serviços backend com autenticação, gestão de utilizadores, fornecedores, agendamentos e chat em tempo real/notificações.

---

## 🛠️ Tecnologias e Ferramentas

- **Linguagem:** [Dart](https://dart.dev/)
- **Framework Web:** [Shelf](https://pub.dev/packages/shelf) & `shelf_router`
- **Injeção de Dependências:** `GetIt` + `Injectable`
- **Segurança & Autenticação:** JWT (JSON Web Tokens), Bcrypt & Middlewares customizados
- **Containerização:** Docker & Dockerfile
- **Push Notifications / Firebase:** Firebase Admin (`service-account.json`)

---

## 📂 Arquitetura do Projeto

O projeto adota uma arquitetura modular baseada em responsabilidades bem definidas:

```text
lib/
├── app/
│   ├── config/         # Injeção de dependências (GetIt/Injectable) e configs globais
│   ├── database/       # Conexão e abstrações de Banco de Dados
│   ├── exceptions/     # Tratamento de exceções customizadas
│   ├── helpers/        # Utilitários (JWT, Crypto, Bcrypt, Request Mapping)
│   ├── logs/           # Logger da aplicação
│   ├── middlewares/    # Middlewares (CORS, Segurança, Content-Type)
│   └── models/         # Entidades de domínio (User, Chat, Supplier, etc.)
└── modules/            # Módulos de negócio da API
    ├── category/       # Módulo de Categorias
    ├── chat/           # Controllers, Repositories, Services e Routers de Chat
    ├── fornecedor/     # Módulo de Fornecedores
    ├── schedule/       # Módulo de Agendamentos
    └── user/           # Autenticação, gestão de utilizadores e ViewModels
```

---

## ⚙️ Pré-requisitos

- **Dart SDK** (v3.0.0 ou superior)
- **Docker** (Opcional, para execução via container)

---

## 🚀 Como Executar Localmente

### 1. Clonar o repositório
```bash
git clone https://github.com/seu-usuario/shelf_apis.git
cd shelf_apis
```

### 2. Configurar Variáveis de Ambiente
Crie um arquivo `.env` na raiz do projeto com as credenciais e configurações necessárias:

```env
PORT=8080
DATABASE_URL=...
JWT_SECRET=...
```

> **Atenção:** Se o projeto utiliza os serviços do Firebase, inclua o seu arquivo `service-account.json` na raiz do projeto localmente.

### 3. Instalar Dependências
```bash
dart pub get
```

### 4. Gerar Injeção de Dependências (`build_runner`)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Iniciar o Servidor
```bash
dart run bin/server.dart
```

O servidor estará rodando no endereço base `http://localhost:8080` (ou na porta configurada no seu `.env`).

---

## 🐳 Executando com Docker

Para rodar a aplicação em um ambiente isolado via Docker:

```bash
# Construir a imagem Docker
docker build -t shelf_apis .

# Executar o container
docker run -p 8080:8080 --env-file .env shelf_apis
```

---

## 📄 Licença

Este projeto está sob a licença MIT.