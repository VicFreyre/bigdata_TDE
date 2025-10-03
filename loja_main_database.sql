
-- Criação de esquema
CREATE SCHEMA loja;

-- Criaçao tabela Clientes
CREATE TABLE loja.Clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15)
);

-- Criaçao tabela Produtos
CREATE TABLE loja.Produtos (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco NUMERIC(10,2) NOT NULL CHECK (preco >= 0),
    estoque INT NOT NULL CHECK (estoque >= 0)
);

-- Criaçaotabela Pedidos
CREATE TABLE loja.Pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido TIMESTAMP NOT NULL DEFAULT NOW(),
    status VARCHAR(20) CHECK (status IN ('PENDENTE','PAGO')),
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES loja.Clientes (id_cliente)
);

-- Criaçao tabela Itens do Pedido
CREATE TABLE loja.Itens_Pedido (
    id_item SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario >= 0),
    CONSTRAINT fk_pedido FOREIGN KEY (id_pedido) REFERENCES loja.Pedidos (id_pedido),
    CONSTRAINT fk_produto FOREIGN KEY (id_produto) REFERENCES loja.Produtos (id_produto)
);

-- Criaçao tabela Pagamentos
CREATE TABLE loja.Pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    valor NUMERIC(10,2) NOT NULL CHECK (valor >= 0),
    data_pagamento TIMESTAMP NOT NULL DEFAULT NOW(),
    metodo_pagamento VARCHAR(20),
    CONSTRAINT fk_pedido_pag FOREIGN KEY (id_pedido) REFERENCES loja.Pedidos (id_pedido)
);

-- Inserindo Clientes
INSERT INTO loja.Clientes (nome, email, telefone) VALUES
('Carlos Silva', 'carlos@email.com', '11988887777'),
('Ana Souza', 'ana@email.com', '21977776666');

-- Inserindo Produtos
INSERT INTO loja.Produtos (nome, preco, estoque) VALUES
('Notebook', 3500.00, 10),
('Mouse Gamer', 120.00, 50),
('Teclado Mecânico', 250.00, 20);

INSERT INTO loja.Pedidos (id_cliente, status) VALUES
(1, 'PENDENTE'),
(2, 'PAGO');

INSERT INTO loja.Itens_Pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 3500.00),
(1, 2, 2, 150.00),
(2, 3, 1, 300.00);

INSERT INTO loja.Pagamentos (id_pedido, valor, metodo_pagamento) VALUES
(2, 300.00, 'Pix');

SELECT p.id_pedido, c.nome, p.status, p.data_pedido
FROM loja.Pedidos p
JOIN loja.Clientes c ON p.id_cliente = c.id_cliente;

-- b) Itens de cada pedido com produto
SELECT ip.id_item, p.id_pedido, pr.nome, ip.quantidade, ip.preco_unitario
FROM loja.Itens_Pedido ip
JOIN loja.Produtos pr ON ip.id_produto = pr.id_produto
JOIN loja.Pedidos p ON ip.id_pedido = p.id_pedido;

-- c) Mostrar pagamentos com nome do cliente
SELECT pa.id_pagamento, c.nome, pa.valor, pa.metodo_pagamento
FROM loja.Pagamentos pa
JOIN loja.Pedidos p ON pa.id_pedido = p.id_pedido
JOIN loja.Clientes c ON p.id_cliente = c.id_cliente;

-- d) Pedidos com total calculado
SELECT p.id_pedido, c.nome, SUM(ip.quantidade * ip.preco_unitario) AS total
FROM loja.Pedidos p
JOIN loja.Clientes c ON p.id_cliente = c.id_cliente
JOIN loja.Itens_Pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY p.id_pedido, c.nome;

-- ===========================================
-- 5) CONSULTAS COM EXISTS E IN
-- ===========================================
--  Clientes que já fizeram pedidos
SELECT nome FROM loja.Clientes c
WHERE EXISTS (SELECT 1 FROM loja.Pedidos p WHERE p.id_cliente = c.id_cliente);

--  Produtos que já foram vendidos
SELECT nome FROM loja.Produtos
WHERE id_produto IN (SELECT id_produto FROM loja.Itens_Pedido);

--  Pedidos que possuem pagamentos
SELECT id_pedido FROM loja.Pedidos
WHERE EXISTS (SELECT 1 FROM loja.Pagamentos pa WHERE pa.id_pedido = Pedidos.id_pedido);

--  Clientes que compraram Notebook
SELECT nome FROM loja.Clientes
WHERE id_cliente IN (
    SELECT p.id_cliente
    FROM loja.Pedidos p
    JOIN loja.Itens_Pedido ip ON p.id_pedido = ip.id_pedido
    JOIN loja.Produtos pr ON ip.id_produto = pr.id_produto
    WHERE pr.nome = 'Notebook'
);

-- ===========================================
-- 6) CRIAÇÃO DAS VIEWS
-- ===========================================
-- View: Pedidos por Cliente
CREATE VIEW vw_pedidos_cliente AS
SELECT c.nome, p.id_pedido, p.status, p.data_pedido
FROM loja.Clientes c
JOIN loja.Pedidos p ON c.id_cliente = p.id_cliente;

-- View: Itens de Pedido Detalhados
CREATE VIEW vw_itens_pedido AS
SELECT p.id_pedido, pr.nome AS produto, ip.quantidade, ip.preco_unitario
FROM loja.Itens_Pedido ip
JOIN loja.Produtos pr ON ip.id_produto = pr.id_produto
JOIN loja.Pedidos p ON ip.id_pedido = p.id_pedido;

-- View: Pagamentos por Pedido
CREATE VIEW vw_pagamentos_pedido AS
SELECT p.id_pedido, pa.valor, pa.metodo_pagamento, pa.data_pagamento
FROM loja.Pagamentos pa
JOIN loja.Pedidos p ON pa.id_pedido = p.id_pedido;

-- View: Resumo de Pedidos com Total
CREATE VIEW vw_resumo_pedidos AS
SELECT p.id_pedido, c.nome, SUM(ip.quantidade) AS total_itens,
       SUM(ip.quantidade * ip.preco_unitario) AS valor_total
FROM loja.Pedidos p
JOIN loja.Clientes c ON p.id_cliente = c.id_cliente
JOIN loja.Itens_Pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY p.id_pedido, c.nome;
SELECT * FROM vw_pedidos_cliente;
SELECT * FROM vw_itens_pedido;
SELECT * FROM vw_pagamentos_pedido;
SELECT * FROM vw_resumo_pedidos;


