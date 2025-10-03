-- ===============================
-- 5) CONSULTAS COM EXISTS E IN
-- ===============================

-- Clientes que já fizeram pedidos
SELECT nome FROM loja.Clientes c
WHERE EXISTS (SELECT 1 FROM loja.Pedidos p WHERE p.id_cliente = c.id_cliente);

-- Produtos que já foram vendidos
SELECT nome FROM loja.Produtos
WHERE id_produto IN (SELECT id_produto FROM loja.Itens_Pedido);

-- Pedidos que possuem pagamentos
SELECT id_pedido FROM loja.Pedidos
WHERE EXISTS (SELECT 1 FROM loja.Pagamentos pa WHERE pa.id_pedido = Pedidos.id_pedido);

-- Clientes que compraram Notebook
SELECT nome FROM loja.Clientes
WHERE id_cliente IN (
    SELECT p.id_cliente
    FROM loja.Pedidos p
    JOIN loja.Itens_Pedido ip ON p.id_pedido = ip.id_pedido
    JOIN loja.Produtos pr ON ip.id_produto = pr.id_produto
    WHERE pr.nome = 'Notebook'
);
