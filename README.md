# 🛠 Desafio Técnico – Desenvolvedor(a) Fullstack Ruby on Rails (Soutag)

## 🎯 Objetivo  
Avaliar sua capacidade de implementar regras de negócio, organizar código de forma escalável e construir uma API realista com boas práticas usando **Rails API**.

---

## 💡 Contexto

Na Soutag, motoristas abastecem em postos parceiros usando a carteira digital e recebem descontos por litro abastecido. Seu desafio será simular esse fluxo.

---

## 💻 Desafio

Implemente uma API com as seguintes entidades e regras:

### 📦 Modelos

- **Usuário**
  - nome, email, saldo (float)

- **Posto de Combustível**
  - nome, endereço, preço por litro (float), produto (ex: gasolina, etanol, diesel)

- **Abastecimento (Refueling)**
  - usuário, posto, quantidade em litros, preço total, desconto aplicado

### 📜 Regras de Negócio

- O valor total do abastecimento é `litros * preço por litro`
- O sistema aplica um **desconto fixo de 5%**
- Além disso, aplicar **um desconto adicional por tipo de produto**, conforme:
  - **Gasolina**: 2%
  - **Etanol**: 1%
  - **Diesel**: 0%
- O valor final (com todos os descontos) deve ser debitado do saldo do usuário
- O abastecimento deve ser registrado
- Não permitir abastecimentos com saldo insuficiente

---

## 🔌 Endpoints esperados

- `POST /refuelings` – realiza um abastecimento
- `GET /users/:id` – exibe dados do usuário e histórico de abastecimentos
- `GET /gasstations` – lista os postos, produtos e preços

---

## 🛡️ Requisitos Técnicos

- **Rails API**
- Banco de dados: SQLite (em memória) ou PostgreSQL
- Organização de código usando **services** para regras de negócio
- Testes cobrindo o fluxo principal
- README com:
  - Instruções de setup local
  - Suas decisões técnicas e de modelagem

---

## 🚀 Como entregar

1. Faça um fork ou clone deste repositório
2. Crie sua solução em uma branch separada
3. Abra um **Pull Request** com sua entrega
4. Avise quando estiver pronto para avaliação

---

## ⏰ Prazo sugerido

**1 dia.**  
Se precisar de mais tempo, sem problema — nos avise.

---
