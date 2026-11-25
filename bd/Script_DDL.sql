create database empresa_funcionarios;

use empresa_funcionarios;

-- CRIAÇÃO DA TABELA ORG (organização matriz e filiais)
CREATE TABLE ORG
(
  DEPTCOD   	INT NOT NULL,
  DEPTNOME 		VARCHAR(20),
  GERENTE   	INT,
  DIVISAO      	VARCHAR(10),
  LOCAL        	VARCHAR(20),
  CONSTRAINT 	PK_ORG PRIMARY KEY (DEPTCOD)
);

-- CRIAÇÃO DA TABELA STAFF (funcionários)
CREATE TABLE STAFF
(
 ID         INT,
 NOME  		VARCHAR(20),
 DEPT   	INT,
 CARGO 		VARCHAR(6),
 ANOS  		INT,
 SALARIO 	DECIMAL(8,2),
 COMIS 		DECIMAL(6,2),
 CONSTRAINT PK_STAFF PRIMARY KEY (ID),
 CONSTRAINT FK_STAFF FOREIGN KEY (DEPT) REFERENCES ORG(DEPTCOD)
);

-- inserindo registros de dados na tabela ORG
INSERT INTO ORG 
VALUES 
(10, 'MATRIZ', 160, 'CENTRO', 'SÃO PAULO'),
(15, 'CAMPINAS', 50, 'SUDESTE', 'CAMPINAS'),
(20, 'RIO', 10, 'SUDESTE', 'R.JANEIRO'),
(38, 'MINAS', 30, 'SUDESTE', 'B.HORIZONTE'),
(42, 'BAHIA', 100, 'NORDESTE', 'SALVADOR'),
(51, 'RECIFE', 140, 'NORDESTE', 'RECIFE'),
(66, 'RIO GRANDE', 270, 'SUL', 'PORTO ALEGRE'),
(84, 'PARANA', 290, 'SUL', 'CURITIBA');

-- inserindo registros de dados na tabela STAFF
INSERT INTO STAFF VALUES 
(10, 'SANTANA', 20, 'GER', 7, 18357.50, NULL),
(20, 'ORSINI', 20, 'VENDAS', 8, 18171.25, 612.45),
(30, 'DANTAS', 38, 'GER', 5, 17506.75, NULL),
(40, 'O´BRIEN', 38, 'VENDAS', 6, 18006.00, 846.55),
(50, 'SOUZA', 15, 'GER', 10, 20659.80, NULL),
(60, 'SUZUKI', 38, 'VENDAS', NULL, 16808.30, 650.25),
(70, 'ALMEIDA', 15, 'VENDAS', 7, 16502.83, 1152.00),
(80, 'JAMES', 20, 'ATEND', NULL, 13504.60, 128.20),
(90, 'KOONITZ', 42, 'VENDAS', 6, 18001.75, 1386.70),
(100, 'PLOTZ', 42, 'GER', 7, 18352.80, NULL),
(110, 'NGAN', 15, 'ATEND', 5, 12508.20, 206.60),
(120, 'NAUGHTON', 38, 'ATEND', NULL, 12954.75, 180.00),
(130, 'YAMAGUCHI', 42, 'ATEND', 6, 10505.90, 75.60),
(140, 'FRAYE', 51, 'GER', 6, 21150.00, NULL),
(150, 'OLIVEIRA', 51, 'VENDAS', 6, 19456.50, 637.65),
(160, 'MOLINARI', 10, 'GER', 7, 22959.20, NULL),
(170, 'KERMISCH', 15, 'ATEND', 4, 12258.50, 110.10),
(180, 'ABRAHAMS', 38, 'ATEND', 3, 12009.75, 236.50),
(190, 'SNEIDER', 20, 'ATEND', 8, 14252.75, 126.50),
(200, 'SCOUTTEN', 42, 'ATEND', NULL, 11508.60, 84.20),
(210, 'LU', 10, 'GER', 10, 20010.00, NULL),
(220, 'SMITH', 51, 'VENDAS', 7, 17654.50, 992.80),
(230, 'LUNDQUIST', 51, 'ATEND', 3, 13369.80, 189.65),
(240, 'DANIELS', 10, 'GER', 5, 19260.25, NULL),
(250, 'WHEELER', 51, 'ATEND', 6, 14460.00, 513.30),
(260, 'JONES', 10, 'GER', 12, 21234.00, NULL),
(270, 'LEA', 66, 'GER', 9, 18555.50, NULL),
(280, 'WILSON', 66, 'VENDAS', 9, 18674.50, 811.50),
(290, 'PINHO', 84, 'GER', 10, 19818.00, NULL),
(300, 'DAVIS', 84, 'VENDAS', 5, 15454.50, 806.10),
(310, 'GRAHAM', 66, 'VENDAS', 13, 21000.00, 200.30),
(320, 'GONZALES', 66, 'VENDAS', 4, 16858.20, 844.00),
(330, 'BURKE', 66, 'ATEND', 1, 10988.00, 55.50),
(340, 'VIEIRA', 84, 'VENDAS', 7, 17844.00, 1285.00),
(350, 'GARNEY', 84, 'ATEND', 5, 13030.50, 188.00);

select * from org;
select * from staff;

-- lsita de exercícios EMPRESA-FUNCIONARIOS 

-- Exercicio 01. Liste os Departamentos cuja Média salarial seja 
-- inferior a MÉDIA da companinha (empresa). Ignore os GERENTES 
-- Mostre as MÉDIAS e ordene por elas. 



SELECT FILIAL.DEPTNOME,
       FORMAT(AVG(EMP.SALARIO), 2) AS 'Média Salarial Departamento'
FROM   ORG AS FILIAL,
       STAFF AS EMP
WHERE  FILIAL.DEPTCOD = EMP.DEPT
  AND  EMP.CARGO    NOT LIKE 'GER'
GROUP BY FILIAL.DEPTNOME
HAVING AVG(EMP.SALARIO) < (SELECT FORMAT(AVG(STAFF.SALARIO),2)
                               FROM STAFF)
ORDER BY 2;


-- Exercício 02 - Simule e mostre os salários reajustados,
-- agrupados pela localidade, sendo que a região SUDESTE receba
-- um aumento de 10%, NORDESTE um reajuste de 15% e a região
-- SUL um aumento salarial de 20%. Ignore os salários da
-- região CENTRO.
SELECT ORG.DIVISAO, STAFF.NOME,
       STAFF.SALARIO,
       FORMAT((STAFF.SALARIO * 0.10),2) AS 'Reajuste',
       FORMAT((STAFF.SALARIO * 1.10),2) AS 'Salário reajustado'
FROM ORG, STAFF
WHERE ORG.DEPTCOD = STAFF.DEPT
  AND ORG.DIVISAO LIKE 'SUDESTE'
UNION
SELECT ORG.DIVISAO, STAFF.NOME,
       STAFF.SALARIO,
       FORMAT((STAFF.SALARIO * 0.15),2) AS 'Reajuste',
       FORMAT((STAFF.SALARIO * 1.15),2) AS 'Salário reajustado'
FROM ORG, STAFF
WHERE ORG.DEPTCOD = STAFF.DEPT
  AND ORG.DIVISAO LIKE 'NORDESTE'
UNION
SELECT ORG.DIVISAO, STAFF.NOME,
       STAFF.SALARIO,
       FORMAT((STAFF.SALARIO * 0.20),2) AS 'Reajuste',
       FORMAT((STAFF.SALARIO * 1.20),2) AS 'Salário reajustado'
FROM ORG, STAFF
WHERE ORG.DEPTCOD = STAFF.DEPT
  AND ORG.DIVISAO LIKE 'SUL';


-- Exercício 03 - Liste os funcionários com salário superior à
-- média da companhia em ordem decrescente
SELECT S.*
FROM STAFF AS S
WHERE S.SALARIO < (SELECT AVG(STAFF.SALARIO) FROM STAFF)
ORDER BY S.SALARIO DESC;



-- Exercício 04 - Listar os funcionários com SALÁRIO inferior
-- à MÉDIA de algum DEPARTAMENTO, exceto CAMPINAS.
SELECT S.NOME, S.CARGO, S.SALARIO, O.DEPTNOME
FROM STAFF AS S, ORG AS O
WHERE O.DEPTCOD = S.DEPT
  AND S.SALARIO < ANY (SELECT AVG(STAFF.SALARIO)
                       FROM STAFF
                       GROUP BY STAFF.DEPT);


-- Exercício 05 - Selecione o NOME, o CARGO e o TEMPO DE SERVIÇO
-- dos funcionários que recebem as três maiores comissões
SELECT STAFF.NOME as 'Nome Funcionário',
       STAFF.CARGO,
       STAFF.ANOS as 'Tempo de Serviço',
       STAFF.COMIS
FROM STAFF
WHERE STAFF.COMIS IS NOT NULL
ORDER BY STAFF.COMIS DESC
LIMIT 3;

-- Exercicio 06 - Atualize uma comissão de 10%
-- para os GERENTES da MATRIZ
-- primeiro iremos simular esse reajuste de comissão
SELECT STAFF.NOME,
       STAFF.CARGO,
       ORG.DEPTNOME,
       STAFF.SALARIO,
       STAFF.SALARIO * 0.10 as 'Comissão 10%'
FROM STAFF, ORG
WHERE ORG.DEPTCOD = STAFF.DEPT
  AND CARGO LIKE 'GER'
  AND ORG.DEPTNOME LIKE 'MATRIZ';
  
  -- agora iremos atualizar a comissão com base nessa simulação
UPDATE STAFF, ORG
SET STAFF.COMIS = STAFF.SALARIO * 0.10
WHERE ORG.DEPTCOD = STAFF.DEPT
  AND CARGO LIKE 'GER'
  AND ORG.DEPTNOME LIKE 'MATRIZ'; 
