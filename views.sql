-- ===============================
-- 6) VIEWS
-- ===============================

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

-- Testando as Views
SELECT * FROM vw_pedidos_cliente;
SELECT * FROM vw_itens_pedido;
SELECT * FROM vw_pagamentos_pedido;
SELECT * FROM vw_resumo_pedidos;
