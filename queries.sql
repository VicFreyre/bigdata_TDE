-- ===============================
-- 4) CONSULTAS
-- ===============================

-- a) Pedidos com cliente
SELECT p.id_pedido, c.nome, p.status, p.data_pedido
FROM loja.Pedidos p
JOIN loja.Clientes c ON p.id_cliente = c.id_cliente;

-- b) Itens de cada pedido com produto
SELECT ip.id_item, p.id_pedido, pr.nome, ip.quantidade, ip.preco_unitario
FROM loja.Itens_Pedido ip
JOIN loja.Produtos pr ON ip.id_produto = pr.id_produto
JOIN loja.Pedidos p ON ip.id_pedido = p.id_pedido;

-- c) Pagamentos com nome do cliente
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
