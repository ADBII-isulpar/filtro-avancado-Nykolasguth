-- =========================
-- CRIAÇÃO DO BANCO E TABELAS
-- =========================
DROP DATABASE IF EXISTS adbII_revisao;
CREATE DATABASE adbII_revisao;
USE adbII_revisao;
-- Clientes
CREATE TABLE Clientes (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(100) NOT NULL,
 email VARCHAR(100) UNIQUE
);
-- Pedidos
CREATE TABLE Pedidos (
 id INT AUTO_INCREMENT PRIMARY KEY,
 cliente_id INT,
 data_pedido DATE NOT NULL,
 total_pedido DECIMAL(10,2),
 FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);
-- Produtos
CREATE TABLE Produtos (
 id INT AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(100) NOT NULL,
 preco DECIMAL(10,2) NOT NULL
);
-- Itens de Pedido
CREATE TABLE ItensPedido (
 id INT AUTO_INCREMENT PRIMARY KEY,
 pedido_id INT,
 produto_id INT,
 quantidade INT,
 preco_unitario DECIMAL(10,2),
 FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
 FOREIGN KEY (produto_id) REFERENCES Produtos(id)
)-- Descontos (para questão de JOIN com condição temporal)
CREATE TABLE Descontos (
 id INT AUTO_INCREMENT PRIMARY KEY,
 produto_id INT,
 inicio DATE,
 fim DATE,
 porcentagem DECIMAL(5,2),
 FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);
-- =========================
-- INSERÇÃO DE DADOS
-- =========================
-- Clientes
INSERT INTO Clientes (nome, email) VALUES
('Ana Souza', 'ana@email.com'),
('Bruno Lima', 'bruno@email.com'),
('Carla Mendes', 'carla@email.com'),
('Diego Rocha', 'diego@email.com'),
('Elisa Ramos', 'elisa@email.com');
-- Produtos
INSERT INTO Produtos (nome, preco) VALUES
('Notebook', 3500.00),
('Mouse Gamer', 120.00),
('Teclado Mecânico', 450.00),
('Monitor 24"', 900.00),
('Headset', 300.00),
('Cadeira Gamer', 1100.00);
-- Pedidos
INSERT INTO Pedidos (cliente_id, data_pedido, total_pedido) VALUES
(1, '2025-01-15', 3620.00),
(2, '2025-02-10', 1470.00),
(2, '2025-03-20', 120.00),
(3, '2025-05-05', 1550.00),
(4, '2025-06-25', 300.00);
-- Itens de Pedido
INSERT INTO ItensPedido (pedido_id, produto_id, quantidade, preco_unitario)
VALUES
-- Pedido 1 (Ana Souza)
(1, 1, 1, 3500.00), -- Notebook
(1, 2, 1, 120.00), -- Mouse Gamer
-- Pedido 2 (Bruno Lima)
(2, 3, 2, 450.00), -- Teclado Mecânico
(2, 4, 1, 900.00), -- Monitor 24"
-- Pedido 3 (Bruno Lima - só mouse)
(3, 2, 1, 120.00), -- Mouse Gamer
-- Pedido 4 (Carla Mendes)
(4, 5, 2, 300.00), -- Headset-- Pedido 5 (Diego Rocha)
(5, 2, 1, 120.00), -- Mouse Gamer
(5, 5, 1, 300.00); -- Headset
-- Descontos
INSERT INTO Descontos (produto_id, inicio, fim, porcentagem) VALUES
(2, '2025-02-01', '2025-02-28', 10.00), -- Mouse Gamer em promoção fevereiro
(3, '2025-03-01', '2025-04-30', 15.00), -- Teclado em março/abril
(5, '2025-06-01', '2025-06-30', 20.00); -- Headset em junho

-1- dml/dll
DDL (Data Definition Language): define a estrutura do banco.
Exemplo:
CREATE TABLE Produtos (
    id INT PRIMARY KEY,
    nome VARCHAR(100),
    preco DECIMAL(10,2)
);
Usado para criar/alterar objetos.

DML (Data Manipulation Language): manipula os dados.
Exemplo:
INSERT INTO Produtos (id, nome, preco)
VALUES (1, 'Notebook', 3500.00);

Usado para inserir, atualizar, deletar registros.

SQL (no geral): é a linguagem completa (englobando DDL, DML, DCL, TCL).

-2- WHERE vs HAVING

WHERE filtra linhas antes da agregação.

HAVING filtra depois da agregação (GROUP BY).

Exemplo: produtos cujo total de vendas > 5000 (HAVING é obrigatório aqui):

SELECT produto_id, SUM(quantidade * preco_unitario) AS faturamento
FROM ItensPedido
GROUP BY produto_id
HAVING SUM(quantidade * preco_unitario) > 5000;

-3-Consulta com filtro e ordenação

SELECT nome, salario
FROM Funcionarios
WHERE salario > 3000
ORDER BY salario DESC;

-4-Agregação e expressão

SELECT produto,
       SUM(quantidade * valor_unitario) AS faturamento_total
FROM Vendas
GROUP BY produto
ORDER BY faturamento_total DESC;

-5-GROUP BY com HAVING

SELECT produto,
       SUM(quantidade * valor_unitario) AS faturamento_total
FROM Vendas
GROUP BY produto
HAVING SUM(quantidade * valor_unitario) > 5000;

Explicação: HAVING é necessário porque o filtro é feito sobre o resultado da agregação.

-5-INNER JOIN — básico

SELECT p.id AS pedido_id,
       p.data_pedido,
       c.nome AS cliente_nome
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id;

-7-INNER JOIN — múltiplas tabelas

SELECT ip.pedido_id,
       p.data_pedido,
       c.nome AS cliente_nome,
       pr.nome AS produto_nome,
       ip.quantidade,
       (ip.quantidade * ip.preco_unitario) AS valor_total_linha
FROM ItensPedido ip
INNER JOIN Pedidos p ON ip.pedido_id = p.id
INNER JOIN Clientes c ON p.cliente_id = c.id
INNER JOIN Produtos pr ON ip.produto_id = pr.id;

-8-LEFT JOIN — clientes sem pedidos

SELECT c.id AS cliente_id,
       c.nome,
       MAX(p.id) AS ultimo_pedido_id
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nome;


LEFT JOIN é adequado pois garante que clientes sem pedidos também apareçam.

-9-RIGHT JOIN — equivalência com LEFT JOIN

-- RIGHT JOIN
SELECT pr.id AS produto_id,
       pr.nome,
       ip.pedido_id
FROM ItensPedido ip
RIGHT JOIN Produtos pr ON ip.produto_id = pr.id;

-- Equivalente com LEFT JOIN (tabelas invertidas)
SELECT pr.id AS produto_id,
       pr.nome,
       ip.pedido_id
FROM Produtos pr
LEFT JOIN ItensPedido ip ON ip.produto_id = pr.id;


As duas dão o mesmo resultado, pois RIGHT JOIN de A com B equivale a LEFT JOIN de B com A.

-10-FULL OUTER JOIN (e emulação)

FULL OUTER JOIN retorna registros de ambas as tabelas, mesmo sem correspondência.

Emulação no MySQL (com UNION):

SELECT c.id AS cliente_id, c.nome, p.id AS pedido_id
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
UNION
SELECT c.id AS cliente_id, c.nome, p.id AS pedido_id
FROM Clientes c
RIGHT JOIN Pedidos p ON c.id = p.cliente_id;

-11-JOIN com condição adicional (theta join)

SELECT ip.id AS item_id,
       p.data_pedido,
       d.porcentagem
FROM ItensPedido ip
INNER JOIN Pedidos p ON ip.pedido_id = p.id
INNER JOIN Descontos d 
       ON ip.produto_id = d.produto_id
      AND p.data_pedido BETWEEN d.inicio AND d.fim;
      
-12-Ambiguidade de colunas e aliases

SELECT c.id AS cliente_id,
       p.id AS pedido_id,
       c.nome AS cliente_nome
FROM Clientes c
INNER JOIN Pedidos p ON c.id = p.cliente_id;

-13-Agregação com JOIN

SELECT c.id AS cliente_id,
       c.nome,
       SUM(ip.quantidade * ip.preco_unitario) AS faturamento_total_cliente
FROM Clientes c
INNER JOIN Pedidos p ON c.id = p.cliente_id
INNER JOIN ItensPedido ip ON p.id = ip.pedido_id
GROUP BY c.id, c.nome
ORDER BY faturamento_total_cliente DESC;

-14-LEFT JOIN + COALESCE

SELECT pr.id AS produto_id,
       pr.nome,
       COALESCE(SUM(ip.quantidade), 0) AS total_vendido
FROM Produtos pr
LEFT JOIN ItensPedido ip ON pr.id = ip.produto_id
GROUP BY pr.id, pr.nome;

-15-Filtro após JOIN + ordenação

SELECT p.id AS pedido_id,
       p.data_pedido,
       c.nome AS cliente_nome,
       p.total_pedido
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
WHERE p.data_pedido BETWEEN '2025-01-01' AND '2025-06-30'
ORDER BY p.data_pedido ASC;