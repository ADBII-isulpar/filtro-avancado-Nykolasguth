-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: mysql
-- Tempo de geração: 09/09/2025 às 00:50
-- Versão do servidor: 8.0.43
-- Versão do PHP: 8.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `nykolas_gt_db`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `Departamentos`
--

CREATE TABLE `Departamentos` (
  `id_departamento` int NOT NULL,
  `nome_departamento` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Despejando dados para a tabela `Departamentos`
--

INSERT INTO `Departamentos` (`id_departamento`, `nome_departamento`) VALUES
(1, 'Vendas'),
(2, 'Marketing'),
(3, 'Financeiro'),
(4, 'TI');

-- --------------------------------------------------------

--
-- Estrutura para tabela `Funcionarios`
--

CREATE TABLE `Funcionarios` (
  `id_funcionario` int NOT NULL,
  `nome_funcionario` varchar(50) DEFAULT NULL,
  `salario` decimal(10,2) DEFAULT NULL,
  `id_departamento` int DEFAULT NULL,
  `id_gerente` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Despejando dados para a tabela `Funcionarios`
--

INSERT INTO `Funcionarios` (`id_funcionario`, `nome_funcionario`, `salario`, `id_departamento`, `id_gerente`) VALUES
(1, 'Ana Silva', 6000.00, 1, NULL),
(2, 'Bruno Costa', 3000.00, 1, 1),
(3, 'Carla Lima', 2000.00, 1, 1),
(4, 'Daniel Pereira', 7000.00, 2, NULL),
(5, 'Eliane Santos', 4500.00, 2, 4),
(6, 'Fabio Oliveira', 5500.00, 3, NULL),
(7, 'Gabriela Rocha', 8000.00, 4, NULL),
(8, 'Henrique Souza', 4000.00, 4, 7),
(9, 'Isabela Martins', 2200.00, 1, 1),
(10, 'Julia Alves', 6500.00, 2, 4),
(11, 'Luiz Felipe', 9000.00, 4, 7);

-- --------------------------------------------------------

--
-- Estrutura para tabela `Projetos`
--

CREATE TABLE `Projetos` (
  `id_projeto` int NOT NULL,
  `nome_projeto` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Despejando dados para a tabela `Projetos`
--

INSERT INTO `Projetos` (`id_projeto`, `nome_projeto`) VALUES
(101, 'Projeto Alfa'),
(102, 'Projeto Beta'),
(103, 'Projeto Gama'),
(104, 'Projeto Delta'),
(105, 'Projeto Epsilon');

-- --------------------------------------------------------

--
-- Estrutura para tabela `Projetos_Funcionarios`
--

CREATE TABLE `Projetos_Funcionarios` (
  `id_funcionario` int NOT NULL,
  `id_projeto` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Despejando dados para a tabela `Projetos_Funcionarios`
--

INSERT INTO `Projetos_Funcionarios` (`id_funcionario`, `id_projeto`) VALUES
(1, 101),
(2, 101),
(10, 101),
(2, 102),
(4, 102),
(5, 102),
(1, 103),
(6, 103),
(1, 104),
(7, 104),
(8, 104),
(11, 104);

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `Departamentos`
--
ALTER TABLE `Departamentos`
  ADD PRIMARY KEY (`id_departamento`);

--
-- Índices de tabela `Funcionarios`
--
ALTER TABLE `Funcionarios`
  ADD PRIMARY KEY (`id_funcionario`),
  ADD KEY `id_departamento` (`id_departamento`);

--
-- Índices de tabela `Projetos`
--
ALTER TABLE `Projetos`
  ADD PRIMARY KEY (`id_projeto`);

--
-- Índices de tabela `Projetos_Funcionarios`
--
ALTER TABLE `Projetos_Funcionarios`
  ADD PRIMARY KEY (`id_funcionario`,`id_projeto`),
  ADD KEY `id_projeto` (`id_projeto`);

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `Funcionarios`
--
ALTER TABLE `Funcionarios`
  ADD CONSTRAINT `Funcionarios_ibfk_1` FOREIGN KEY (`id_departamento`) REFERENCES `Departamentos` (`id_departamento`);

--
-- Restrições para tabelas `Projetos_Funcionarios`
--
ALTER TABLE `Projetos_Funcionarios`
  ADD CONSTRAINT `Projetos_Funcionarios_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `Funcionarios` (`id_funcionario`),
  ADD CONSTRAINT `Projetos_Funcionarios_ibfk_2` FOREIGN KEY (`id_projeto`) REFERENCES `Projetos` (`id_projeto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
