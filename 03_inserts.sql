-- ===============================
-- 3) INSERÇÃO DE DADOS
-- ===============================

-- Clientes
INSERT INTO loja.Clientes (nome, email, telefone) VALUES
('Carlos Silva', 'carlos@email.com', '11988887777'),
('Ana Souza', 'ana@email.com', '21977776666');

-- Produtos
INSERT INTO loja.Produtos (nome, preco, estoque) VALUES
('Notebook', 3500.00, 10),
('Mouse Gamer', 120.00, 50),
('Teclado Mecânico', 250.00, 20);

-- Pedidos
INSERT INTO loja.Pedidos (id_cliente, status) VALUES
(1, 'PENDENTE'),
(2, 'PAGO');

-- Itens de Pedido
INSERT INTO loja.Itens_Pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 3500.00),
(1, 2, 2, 150.00),
(2, 3, 1, 300.00);

-- Pagamentos
INSERT INTO loja.Pagamentos (id_pedido, valor, metodo_pagamento) VALUES
(2, 300.00, 'Pix');
