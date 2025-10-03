-- ===============================
-- 2) CRIAÇÃO DAS TABELAS
-- ===============================

-- Clientes
CREATE TABLE loja.Clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15)
);

-- Produtos
CREATE TABLE loja.Produtos (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco NUMERIC(10,2) NOT NULL CHECK (preco >= 0),
    estoque INT NOT NULL CHECK (estoque >= 0)
);

-- Pedidos
CREATE TABLE loja.Pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido TIMESTAMP NOT NULL DEFAULT NOW(),
    status VARCHAR(20) CHECK (status IN ('PENDENTE','PAGO')),
    CONSTRAINT fk_cliente FOREIGN KEY (id_cliente) REFERENCES loja.Clientes (id_cliente)
);

-- Itens do Pedido
CREATE TABLE loja.Itens_Pedido (
    id_item SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario >= 0),
    CONSTRAINT fk_pedido FOREIGN KEY (id_pedido) REFERENCES loja.Pedidos (id_pedido),
    CONSTRAINT fk_produto FOREIGN KEY (id_produto) REFERENCES loja.Produtos (id_produto)
);

-- Pagamentos
CREATE TABLE loja.Pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    valor NUMERIC(10,2) NOT NULL CHECK (valor >= 0),
    data_pagamento TIMESTAMP NOT NULL DEFAULT NOW(),
    metodo_pagamento VARCHAR(20),
    CONSTRAINT fk_pedido_pag FOREIGN KEY (id_pedido) REFERENCES loja.Pedidos (id_pedido)
);
