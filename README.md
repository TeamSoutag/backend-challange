# 🛠 Teste Técnico – Desenvolvedor(a) Sênior (Soutag)

**Objetivo:** Avaliar habilidades práticas em backend, lógica de negócios e organização de código, simulando um caso próximo ao dia a dia da Soutag.

---

## 💡 Contexto

Na Soutag, usuários abastecem veículos em postos parceiros e recebem descontos. Queremos criar uma funcionalidade simples para **simular transações de abastecimento com desconto**.

---

## 💻 Desafio

Construa uma **API simples** com as seguintes regras:

### Modelos

- **Usuário**
  - Nome, email, saldo (carteira Soutag).

- **Posto de combustível**
  - Nome, endereço, preço por litro.

- **Abastecimento (Refueling)**
  - Usuário, posto, quantidade (litros), preço total, desconto aplicado.

---

### Regras de negócio

1. Quando um usuário faz um abastecimento:
   - O sistema calcula o valor total: `quantidade * preço por litro`.
   - Aplica um desconto fixo de **5%** no total.
   - Abate o valor (com desconto) do saldo do usuário.
   - Registra o abastecimento.

2. Não permitir abastecimento se o saldo for insuficiente.

---

### Endpoints mínimos

- `POST /refuelings`: criar abastecimento.
- `GET /users/:id`: consultar saldo e histórico de abastecimentos.
- `GET /gasstations`: listar postos e preços.

---

## 🛡️ Requisitos técnicos

- API REST simples (Rails API, Node.js, etc.).
- Banco em memória (sqlite, H2) ou PostgreSQL/MySQL.
- Código organizado (por exemplo, `services` para regras de negócio).
- Testes básicos cobrindo o fluxo principal.
- README com:
  - Setup local.
  - Explicação das decisões de código.

---

## ⏰ Prazo sugerido

- **1 Dia**.
- Se precisar de mais tempo, nos avise!

---

