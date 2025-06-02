# 🛠 Desafio Técnico – Desenvolvedor(a) Fullstack Ruby on Rails (Soutag)

## Smart Refueling Card

Este sistema simula o fluxo de abastecimento em postos parceiros usando uma carteira digital, aplicando regras de desconto e controle de saldo do usuário. A API permite o cadastro de usuários, postos, produtos e o registro de abastecimentos, garantindo que todas as regras de negócio sejam respeitadas.

---

## 💡 Contexto

Motoristas abastecem em postos parceiros usando a carteira digital e recebem descontos por litro abastecido. O sistema gerencia usuários, postos, produtos e abastecimentos, controlando o saldo do usuário e aplicando descontos conforme o tipo de combustível.

---

## 💻 O que o sistema faz

- Cadastro de usuários com nome, email e carteira (wallet).
- Cadastro de postos de combustível, cada um com endereço detalhado e produtos (gasolina, etanol, diesel) e seus preços por litro.
- Cadastro de produtos vinculados a postos via `GasStationProduct`.
- Registro de abastecimentos, vinculando usuário, posto, produto, quantidade em litros, preço total e desconto aplicado.
- Cálculo automático do valor total do abastecimento (`litros * preço por litro`).
- Aplicação de desconto fixo de 5% sobre o valor total.
- Desconto adicional conforme o tipo de produto:
  - Gasolina: `2%`
  - Etanol: `1%`
  - Diesel: `0%`
- Débito do valor final (após descontos) do saldo da carteira do usuário.
- Impede abastecimentos caso o saldo do usuário seja insuficiente.
- Registro de todos os abastecimentos realizados.
- Em caso de exclusão de um abastecimento, o saldo é devolvido para a carteira do usuário.

---

## 📦 Models e exemplos de objetos

### Usuário (`User`)

```json
{
  "id": 1,
  "name": "João Silva",
  "email": "joao.silva@email.com",
  "wallet": {
    "id": 1,
    "balance": 150.00
  },
  "refuelings": [
    {
      "id": 1,
      "gas_station": {
        "id": 1,
        "name": "Posto Central"
      },
      "product": {
        "id": 1,
        "name": "gasolina"
      },
      "liters": 20,
      "total_price": 119.80,
      "discount_applied": 7.18,
      "created_at": "2024-06-01T10:00:00Z"
    }
  ]
}
```

### Posto de Combustível (`GasStation`)

```json
{
  "id": 1,
  "name": "Posto Central",
  "address": {
    "id": 1,
    "acronym": "AV",
    "street": "Av. Brasil",
    "number": "1000",
    "city": "São Paulo",
    "state": "SP",
    "zip_code": "12345-678",
    "street_details": "Em frente ao shopping"
  },
  "products": [
    {
      "id": 1,
      "name": "gasolina",
      "gas_station_product": {
        "price_per_liter": 5.99
      }
    },
    {
      "id": 2,
      "name": "etanol",
      "gas_station_product": {
        "price_per_liter": 4.59
      }
    }
  ]
}
```

### Produto (`Product`)

```json
{
  "id": 1,
  "name": "gasolina",
  "discount": 2
}
```

### GasStationProduct

```json
{
  "id": 1,
  "gas_station_id": 1,
  "product_id": 1,
  "price_per_liter": 5.99
}
```

### Abastecimento (`Refueling`)

```json
{
  "id": 1,
  "user_id": 1,
  "gas_station_id": 1,
  "product_id": 1,
  "liters": 20,
  "total_price": 119.80,
  "discount_applied": 7.18,
  "created_at": "2024-06-01T10:00:00Z"
}
```

### Endereço (`Address`)

```json
{
  "id": 1,
  "acronym": "AV",
  "street": "Av. Brasil",
  "number": "1000",
  "city": "São Paulo",
  "state": "SP",
  "zip_code": "12345-678",
  "street_details": "Em frente ao shopping"
}
```

---

## 📜 Regras de Negócio

- O valor total do abastecimento é `litros * preço por litro`
- O sistema aplica um **desconto fixo de 5%**
- Além disso, aplicar **um desconto adicional por tipo de produto**:
  - **Gasolina**: 2%
  - **Etanol**: 1%
  - **Diesel**: 0%
- O valor final (com todos os descontos) é debitado do saldo da carteira do usuário
- O abastecimento é registrado
- Não permite abastecimentos com saldo insuficiente

---

## 🏗️ Classes de Serviço

As regras de negócio principais estão centralizadas em classes de serviço, garantindo a separação de responsabilidades:

- **RefuelingServices::RefuelingCreator**
  Responsável por todo o fluxo de criação de um abastecimento:
  - Valida se o usuário possui saldo suficiente na carteira.
  - Calcula o preço total e descontos usando o `PriceCalculator`.
  - Debita o valor do saldo do usuário via `WalletServices::Debit`.
  - Cria o registro de abastecimento de forma transacional.

- **RefuelingServices::PriceCalculator**
  Calcula todos os valores envolvidos no abastecimento:
  - Busca o preço do produto no posto selecionado.
  - Calcula o valor base, desconto fixo (5%) e desconto adicional conforme o produto.
  - Retorna o valor final a ser debitado e o total de descontos aplicados.

- **WalletServices::Debit**
  Serviço responsável por debitar valores da carteira do usuário:
  - Garante que não seja possível debitar mais do que o saldo disponível.
  - Lança exceção em caso de saldo insuficiente.

- **RefuelingServices::RefundUser**
  Serviço responsável por estornar um abastecimento:
  - Remove o registro de abastecimento.
  - Devolve o valor total do abastecimento para a carteira do usuário.
  - Garante atomicidade e consistência do saldo.

Essas classes são fundamentais para manter as regras de negócio centralizadas, facilitando manutenção, testes e evolução do sistema.

---

## 🔌 Endpoints

 - `POST /refuelings` – Realiza um abastecimento.
 - `GET /refuelings/:id` – Exibe os detalhes de um abastecimento.
 - `PATCH /refuelings/:id` – Atualiza as informações de um abastecimento.
 - `DELETE /refuelings/:id` – Remove um abastecimento.
 - `GET /refuelings` – Lista todos os abastecimentos.
 - `GET /users` – Lista todos os usuários.
 - `POST /users` – Cria um novo usuário.
 - `GET /users/:id` – Exibe dados do usuário e histórico de abastecimentos.
 - `PATCH /users/:id` – Atualiza as informações de um usuário.
 - `DELETE /users/:id` – Remove um usuário.
 - `GET /users/:user_id/wallet` – Exibe o saldo na carteira do usuário.
 - `POST /users/:user_id/wallet` – Cria uma carteira para o usuário.
 - `PUT /users/:user_id/wallet` – Atualiza o saldo da carteira de um usuário.
 - `GET /gas_stations` – Lista todos os postos, seus produtos e preços.
 - `POST /gas_stations` – Adiciona um novo posto.
 - `GET /gas_stations/:id` – Exibe os detalhes de um posto.
 - `PATCH /gas_stations/:id` – Atualiza as informações de um posto.
 - `DELETE /gas_stations/:id` – Remove um posto.
 - `GET /products` – Lista todos os produtos.
 - `POST /products` – Adiciona um novo produto.
 - `GET /products/:id` – Exibe os detalhes de um produto.
 - `PATCH /products/:id` – Atualiza as informações de um produto.
 - `DELETE /products/:id` – Remove um produto.
---

## ⚙️ Instruções de Configuração

1. **Instale as dependências:**
   ```bash
   bundle install
   ```

2. **Configure e crie o banco de dados:**
   ```bash
   bin/setup
   ```

3. **Inicie o servidor Rails:**
   ```bash
   rails server
   ```

---

## 🧪 Rodando os Testes

O projeto utiliza RSpec para testes automatizados.

- Para rodar todos os testes:
  ```bash
  bundle exec rspec .
  ```

- Para rodar um teste específico:
  ```bash
  bundle exec rspec ./spec/path/exemplo_spec.rb
  ```

---

## 📝 Decisões Técnicas e Modelagem

- **Separação de responsabilidades:** Toda a lógica de negócio está em services, facilitando manutenção e testes.
- **Modelagem:** Usuários, carteiras, postos, endereços, produtos, preços e abastecimentos são entidades separadas, com seus relacionamentos definidos para serem claros.
- **Validações:** O sistema impede operações inválidas, como abastecimento com saldo insuficiente.
- **Testes:** Cobertura dos fluxos principais, especialmente regras de desconto e débito de saldo.

---
