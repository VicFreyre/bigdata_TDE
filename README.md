# TDE - Sistema de Gestão de Loja 

## 1. Apresentação do Sistema

O sistema foi desenvolvido para **gerenciar uma loja virtual** de forma organizada. Ele permite controlar os **clientes**, os **produtos disponíveis**, os **pedidos realizados**, os **itens dentro de cada pedido** e os **pagamentos efetuados**.  

De forma simplificada, o funcionamento é:

1. **Clientes**: Cada pessoa que compra na loja é cadastrada com nome, email e telefone.  
2. **Produtos**: A loja possui uma lista de produtos à venda, com preço e quantidade em estoque.  
3. **Pedidos**: Quando um cliente realiza uma compra, o pedido é registrado. Cada pedido pode ter vários produtos, cada um com sua quantidade e preço.  
4. **Pagamentos**: É possível registrar o pagamento de um pedido, informando valor e forma de pagamento (como Pix ou cartão).  
5. **Relatórios**: O sistema permite consultar informações como “quais clientes fizeram pedidos”, “itens de cada pedido” e “total gasto por pedido”, além de gerar visões resumidas para facilitar a análise.

**Resumindo:** o sistema acompanha todo o ciclo de uma compra, desde o cadastro do cliente até o pagamento, permitindo consultas detalhadas e relatórios resumidos para tomada de decisão.

---

## 2. Estrututra do Projeto

```
├── 01_schema.sql                -- criação do esquema
├── 02_tables.sql                -- criação das tabelas
├── 03_inserts.sql               -- inserção de dados iniciais (seeds)
├── 04_queries.sql               -- consultas comuns (JOINs, agregações)
├── 05_queries_exists_in.sql     -- consultas com EXISTS e IN
├── 06_views.sql                 -- criação de views
├── loja_main_database.sql       -- código monobloco

```

## 3. Implementação do Sistema

### 3.1 Criação do Schema e Tabelas (DDL)
O banco de dados possui um schema chamado `loja` que organiza todas as tabelas do sistema.

```sql
-- Criação do schema
CREATE SCHEMA loja;
```
## Tabelas Principais

Clientes – Armazena dados de cada cliente.

Produtos – Armazena os produtos disponíveis na loja.

Pedidos – Cada pedido realizado por um cliente.

Itens_Pedido – Produtos e quantidades dentro de cada pedido.

Pagamentos – Controle dos pagamentos realizados.

Exemplo de criação da tabela Clientes:
```sql
CREATE TABLE loja.Clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15)
);
```
As demais tabelas incluem chaves primárias, estrangeiras e restrições, como preço não negativo e quantidade mínima de 1.

## 3.2 Restrições e Chaves

| Tabela        | Chave Primária | Chave Estrangeira                                   | Restrições Adicionais                     |
|---------------|----------------|----------------------------------------------------|------------------------------------------|
| Clientes      | id_cliente     | -                                                  | email único                               |
| Produtos      | id_produto     | -                                                  | preço >= 0, estoque >= 0                 |
| Pedidos       | id_pedido      | id_cliente → Clientes(id_cliente)                  | status: PENDENTE ou PAGO                 |
| Itens_Pedido  | id_item        | id_pedido → Pedidos(id_pedido), id_produto → Produtos(id_produto) | quantidade > 0, preco_unitario >= 0 |
| Pagamentos    | id_pagamento   | id_pedido → Pedidos(id_pedido)                     | valor >= 0                               |

## 3.3 Inserção de Dados (DML)

Clientes:
```sql
INSERT INTO loja.Clientes (nome, email, telefone) VALUES
('Carlos Silva', 'carlos@email.com', '11988887777'),
('Ana Souza', 'ana@email.com', '21977776666');
```

Produtos:
```sql
INSERT INTO loja.Produtos (nome, preco, estoque) VALUES
('Notebook', 3500.00, 10),
('Mouse Gamer', 120.00, 50),
('Teclado Mecânico', 250.00, 20);
```
Pedidos, Itens e Pagamentos seguem a mesma lógica, relacionando clientes aos produtos comprados.

## 4. Consultas SQL (Junções – JOINs)

Pedidos de cada cliente:
```sql
SELECT p.id_pedido, c.nome, p.status, p.data_pedido
FROM loja.Pedidos p
JOIN loja.Clientes c ON p.id_cliente = c.id_cliente;
```
<p align="center">
  <img width="865" height="251" alt="image" src="https://github.com/user-attachments/assets/881293ec-c416-4704-a8a3-afba8bc82958" />
</p>

Itens de cada pedido:
```sql
SELECT ip.id_item, p.id_pedido, pr.nome, ip.quantidade, ip.preco_unitario
FROM loja.Itens_Pedido ip
JOIN loja.Produtos pr ON ip.id_produto = pr.id_produto
JOIN loja.Pedidos p ON ip.id_pedido = p.id_pedido;
```
<p align="center">
  <img width="1133" height="225" alt="image" src="https://github.com/user-attachments/assets/1896c9a9-674e-4294-9b30-13fac39cc1d5" />
</p>

Pagamentos com nome do cliente:
```sql
SELECT pa.id_pagamento, c.nome, pa.valor, pa.metodo_pagamento
FROM loja.Pagamentos pa
JOIN loja.Pedidos p ON pa.id_pedido = p.id_pedido
JOIN loja.Clientes c ON p.id_cliente = c.id_cliente;
```

<p align="center">
  <img width="965" height="167" alt="image" src="https://github.com/user-attachments/assets/d953bf59-7c56-4605-960b-3c2faddf6fe8" />
</p>

Pedidos com total calculado:
```sql
SELECT p.id_pedido, c.nome, SUM(ip.quantidade * ip.preco_unitario) AS total
FROM loja.Pedidos p
JOIN loja.Clientes c ON p.id_cliente = c.id_cliente
JOIN loja.Itens_Pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY p.id_pedido, c.nome;
```

<p align="center">
  <img width="629" height="192" alt="image" src="https://github.com/user-attachments/assets/d7889c33-3def-48da-882d-8409279aeafe" />
</p>

## 5. Consultas com EXISTS e IN
Clientes que já fizeram pedidos:
```sql
SELECT nome FROM loja.Clientes c
WHERE EXISTS (SELECT 1 FROM loja.Pedidos p WHERE p.id_cliente = c.id_cliente);
```
<p align="center">
  <img src="https://github.com/user-attachments/assets/b13bdd0e-b44f-4b1b-bdf8-f5409c40ab37" width="527" height="191" />
</p>


Produtos que já foram vendidos:
```sql
SELECT nome FROM loja.Produtos
WHERE id_produto IN (SELECT id_produto FROM loja.Itens_Pedido);
```
<p align="center">
  <img width="537" height="228" alt="image" src="https://github.com/user-attachments/assets/38533cb4-4a4d-4c5a-b50e-340d991f17dc" />
</p>

Pedidos que possuem pagamentos:
```sql
SELECT id_pedido FROM loja.Pedidos
WHERE EXISTS (SELECT 1 FROM loja.Pagamentos pa WHERE pa.id_pedido = Pedidos.id_pedido);
```
<p align="center">
  <img width="540" height="200" alt="image" src="https://github.com/user-attachments/assets/6735ac83-b821-43bf-9bcf-aafa93d22957" />
</p>

Clientes que compraram Notebook:
```sql
SELECT nome FROM loja.Clientes
WHERE id_cliente IN (
    SELECT p.id_cliente
    FROM loja.Pedidos p
    JOIN loja.Itens_Pedido ip ON p.id_pedido = ip.id_pedido
    JOIN loja.Produtos pr ON ip.id_produto = pr.id_produto
    WHERE pr.nome = 'Notebook'
);
```

<p align="center">
  <img width="526" height="193" alt="image" src="https://github.com/user-attachments/assets/06bcf16e-0a6e-4568-8806-486abbf96166" />
</p>

## 6. Visões (Views)

Pedidos por Cliente:
```sql
CREATE VIEW vw_pedidos_cliente AS
SELECT c.nome, p.id_pedido, p.status, p.data_pedido
FROM loja.Clientes c
JOIN loja.Pedidos p ON c.id_cliente = p.id_cliente;
```
<p align="center">
    <img width="799" height="174" alt="image" src="https://github.com/user-attachments/assets/acac799c-1b17-4bd7-8065-f9147f55afb9" />
</p>

Itens de Pedido Detalhados:
```sql
CREATE VIEW vw_itens_pedido AS
SELECT p.id_pedido, pr.nome AS produto, ip.quantidade, ip.preco_unitario
FROM loja.Itens_Pedido ip
JOIN loja.Produtos pr ON ip.id_produto = pr.id_produto
JOIN loja.Pedidos p ON ip.id_pedido = p.id_pedido;
```
<p align="center">
    <img width="890" height="158" alt="image" src="https://github.com/user-attachments/assets/e18e373b-fc9d-4270-a8c8-011955cc8ebf" />
</p>

Pagamentos por Pedido:
```sql
CREATE VIEW vw_pagamentos_pedido AS
SELECT p.id_pedido, pa.valor, pa.metodo_pagamento, pa.data_pagamento
FROM loja.Pagamentos pa
JOIN loja.Pedidos p ON pa.id_pedido = p.id_pedido;
```
<p align="center">
   <img width="961" height="84" alt="image" src="https://github.com/user-attachments/assets/46c5a8d2-346c-4e5d-af4b-30446d1805a9" />
</p>

Resumo de Pedidos com Total:
```sql
CREATE VIEW vw_resumo_pedidos AS
SELECT p.id_pedido, c.nome, SUM(ip.quantidade) AS total_itens,
       SUM(ip.quantidade * ip.preco_unitario) AS valor_total
FROM loja.Pedidos p
JOIN loja.Clientes c ON p.id_cliente = c.id_cliente
JOIN loja.Itens_Pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY p.id_pedido, c.nome;
```

<p align="center">
    <img width="830" height="114" alt="image" src="https://github.com/user-attachments/assets/b198fbf1-bf70-49e6-a92f-23fe20f1eb54" />
</p>

## 7. Funcionamento do Sistema
O sistema acompanha todo o ciclo de uma compra:

1. **Cadastro de clientes e produtos** – Armazena informações essenciais para vendas.
2. **Gerenciamento de pedidos** – Cada pedido é associado a um cliente e pode conter vários itens.
3. **Controle de estoque** – Cada produto possui quantidade disponível para venda.
4. **Gestão de pagamentos** – Permite registrar pagamentos por pedido.
5. **Relatórios e análises** – Consultas SQL e views permitem análises detalhadas e resumos do desempenho de vendas
   
----

## 🛠️ Desenvolvido por:

| Equipe 04                                     |
|----------------------------------------------|
| Maria Victória Freyre Reis                    |
| Arlington Costa Tavares Junior                |
| Marcus Vinícius Costa Pachêco                  |
| Kayllanne Gabrielle França Oliveira            |
| Dannyelen Christinna Dourado Garcez            |
| Jefferson Freitas Dos Santos                   |

*Este repositória visa contemplar o projeto de Trabalho Discente Efetivo (TDE) da disciplina de Banco de dados Avançado e Big Data.*

