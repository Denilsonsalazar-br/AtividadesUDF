-- LISTA DE EXERCICIOS DE CONSULTA SQL --
-- EXERCICIO 01 --
-- CONSULTAR NOME DO CURSO, TURMA, ANO E PERIODO DA TURMA --
-- "DISTINCT" ELIMINA LINHAS DUPLICADAS ---
SELECT DISTINCT 
curso.nome,
turma.descricao,
turma.ano,
turma.periodo

FROM curso, turma -- inner join turma on curso.co_curso = turma.co_curso; --
WHERE curso.co_curso = turma.co_curso; -- FAZENDO A LIGAÇÃO ENTRE AS TABELAS --

-- --------------------------------------------------------------------------------- --

-- EXERCICIO 02 --
-- SABER QUAIS ALUNOS ESTUDAM EM QUAIS TURMAS --
-- ACRESCENTAR RENOMEAÇÃO DE OBJETOS PARA SIMPLIFICAR --
-- "DISTINCT" ELIMINA LINHAS DUPLICADAS --
SELECT DISTINCT 
turma.descricao		AS 'TURMA',
aluno.co_aluno		AS 'MATRICULA',
aluno.nome			AS 'ALUNO'

FROM turma, aluno, aluno_turma

WHERE turma.co_turma = aluno_turma.co_turma -- FAZENDO ASSOCIAÇÃO DAS TABELAS TURMA COM ALUNO_TURMA --
AND aluno.co_aluno  = aluno_turma.co_aluno; -- FAZENDO ASSOCIAÇÃO DAS TABELAS ALUNO COM ALUNO_TURMA --

-- --------------------------------------------------------------------------------- --

-- CLÁUSULA WHERE --
SELECT * FROM aluno WHERE aluno.sg_sexo = 'M' AND aluno.co_estadocivil LIKE 'C';
-- RESULTADO DE QUAIS ALUNOS SÃO DO SEXO MASCULINO E QUE SÃO CASADOS --

SELECT aluno.nome FROM aluno WHERE aluno.nome LIKE '_M%';
-- O "LIKE" FUNCIONA COMO UM FILTRO DE PESQUISA --
-- % (PERCENTUAL) PARA QUAISQUER CARACTERES
-- _ (UNDERLINE) PARA UM CARACTER QUALQUER 

SELECT * FROM aluno WHERE aluno.nome LIKE '___ONIA%';
-- RETORNA OS NOMES QUE POSSUIE 3 CARACTRES ANTES DO "ONIA" -- 

-- --------------------------------------------------------------------------------- --

-- EXERCICIO 03 --
-- QUERO SABER QUANTAS FALTAS CADA ALUNO TEM EM SUAS DISCIPLINAS --
SELECT 
aluno.nome						AS 'NOME DO ALUNO', -- O "AS" É PARA ADICIONAR UM TITULO DA TABELA, TEMPORÁRIO --
disciplina.no_disciplina		AS 'DISCIPLINA',
count(frequencia.frequencia)	AS 'Nº FALTAS'

FROM aluno, aluno_turma, disciplina, frequencia WHERE frequencia.frequencia LIKE 'N'
AND aluno.co_aluno = aluno_turma.co_aluno       -- ASSOCIAÇÃO DA TABELA ALUNO COM ALUNO_TURMA "ATRAVÉS DA CHAVE CO_ALUNO" --
AND aluno_turma.co_aluno = frequencia.co_aluno  -- ASSOCIAÇÃO DA TABELA ALUNO_TURMA COM FREQUENCIA "COM CHAVE DUPLA - CO_ALUNO" -- 
AND aluno_turma.co_turma = frequencia.co_turma  -- ASSOCIAÇÃO DA TABELA ALUNO_TURMA COM FREQUENCIA "COM CHAVE DUPLA - CO_TURMA" -- 
AND frequencia.co_disciplina = disciplina.co_disciplina -- ASSOCIAÇÃO DA TEBELA FREQUENCIA COM DISCIPLINA " ATRAVÉS DA CHAVE CO_DISCIPLINA" --

GROUP BY aluno.nome, disciplina.no_disciplina
ORDER BY 1 ASC;

-- --------------------------------------------------------------------------------- --

-- EXERCICIO 04 --
-- ================== --
SELECT DISTINCT 
professor.nome					AS 'NOME DO PROFESSOR',
disciplina.no_disciplina		AS 'DISCIPLINA',
turma.descricao					AS 'TURMA'

FROM professor, turma, disciplina, prof_turm_disc 
WHERE professor.co_professor = prof_turm_disc.co_professor 
AND   turma.co_turma = prof_turm_disc.co_turma
AND	  disciplina.co_disciplina = prof_turm_disc.co_disciplina
ORDER BY 1;

-- --------------------------------------------------------------------------------- --
-- --------------------------------------------------------------------------------- --

SELECT DISTINCT
aluno.co_aluno				AS 'Matricula aluno',
aluno.nome					AS 'Nome aluno',
disciplina.no_disciplina	AS 'Disciplina',
prova.ds_prova				AS 'Descrição prova',
avaliacao.dt_avaliacao		AS 'Data da prova',
avaliacao.nt_avaliacao		AS 'Nota da prova'

FROM aluno, aluno_turma, disciplina, avaliacao, prova

WHERE  aluno.co_aluno = aluno_turma.co_aluno -- join entre as tabelas ALUNO com ALUNO_TURMA
AND	   aluno_turma.co_aluno = avaliacao.co_aluno -- join entre as tabelas ALUNO_TUMA com AVALIACAO
AND	   aluno_turma.co_turma = avaliacao.co_turma -- join entre as tabelas ALUNO_TURMA com AVALIACAO
AND	   disciplina.co_disciplina = avaliacao.co_disciplina -- join entre as tabelas DISCIPLINA com AVALIAVCAO
AND	   prova.co_prova = avaliacao.co_prova -- join entre as tabelas PROVA com AVALIACAO

ORDER BY 2, 3, 4 ASC;

-- --------------------------------------------------------------------------------- --

-- EXERCICIO 6 --
-- CONSULTAR O NOME DOS PROFESSORES E AS MATERIAS QUE ELES MINISTRAM: --

SELECT DISTINCT
professor.nome				AS 'Nome do professor',
disciplina.no_disciplina	AS 'Disciplina'

FROM professor, disciplina, prof_turm_disc

WHERE professor.co_professor = prof_turm_disc.co_professor
AND   disciplina.co_disciplina = prof_turm_disc.co_disciplina;

-- --------------------------------------------------------------------------------- --

-- EXERCICIO 7 --
-- ALTERAR A NOTA DO ALUNO 1, DE 3.0 PARA 4.5--

SELECT * FROM avaliacao; 

UPDATE avaliacao
SET avaliacao.nt_avaliacao = 4.5 -- ALTERA A NOTA DE 3 PARA 4.5

WHERE avaliacao.co_aluno = 1
AND	  avaliacao.co_disciplina = 01
AND	  avaliacao.co_prova = 01
AND   dt_avaliacao LIKE '2002-02-05%';

COMMIT; -- COMANDO PARA SALVAR PERMANENTEMANTE AS ALTERAÇÕES --

-- --------------------------------------------------------------------------------- --

-- EXERCICIO 8 --
-- CONSUSLTAR TODOS OS ALUNOS E A MEDIA DAS NOTAS POR DISCIPLINA --

SELECT
aluno.nome									AS 	'Nome do Alumo',
disciplina.no_disciplina					AS  'Disciplina',
FORMAT (AVG(avaliacao.nt_avaliacao), 1) 	AS  'Média Final' 
-- 'FORMAT' USADO PARA LIMITAR AS CASAS DECIMAIS
-- 'AVG' USADO PARA CALCULAR A MEDIA

FROM aluno, aluno_turma, disciplina, avaliacao

WHERE aluno.co_aluno = aluno_turma.co_aluno
AND	  avaliacao.co_aluno = aluno_turma.co_aluno
AND	  avaliacao.co_turma = aluno_turma.co_turma
AND   disciplina.co_disciplina = avaliacao.co_disciplina
GROUP BY aluno.nome, disciplina.no_disciplina
ORDER BY 1, 2, 3;

-- --------------------------------------------------------------------------------- --

-- EXERCICIO 9 --
-- AJUSTE A ULTIMA CONSULTA PARA APRESENTAR APENAS OS ALUNOS 
-- COM MEDIA MAIOR DO QUE 6.0

SELECT
aluno.nome									AS 	'Nome do Alumo',
disciplina.no_disciplina					AS  'Disciplina',
FORMAT (AVG(avaliacao.nt_avaliacao), 1) 	AS  'Média Final' 
-- 'FORMAT' USADO PARA LIMITAR AS CASAS DECIMAIS
-- 'AVG' USADO PARA CALCULAR A MEDIA
-- WHERE (CLÁUSULA SQL QUE FILTRA LINHAS )
-- HAVING (CLÁUSULA SQL QUE FILTRA GRUPOS)

FROM aluno, aluno_turma, disciplina, avaliacao

WHERE aluno.co_aluno = aluno_turma.co_aluno
AND	  avaliacao.co_aluno = aluno_turma.co_aluno
AND	  avaliacao.co_turma = aluno_turma.co_turma
AND   disciplina.co_disciplina = avaliacao.co_disciplina
GROUP BY aluno.nome, disciplina.no_disciplina
HAVING AVG(avaliacao.nt_avaliacao) BETWEEN 7.0 AND 9.0 -- TRAZENDO AS NOTAS ENTRE 7 E 9.
-- HAVING AVG(avaliacao.nt_avaliacao) >= 7.0 AND  AVG(avaliacao.nt_avaliacao) <= 9.0 --
ORDER BY 1, 2, 3;

-- --------------------------------------------------------------------------------- --

-- EXERCICIO 10 --
-- QUANTIDADE DE ALUNOS POR TURMA --

SELECT 
turma.descricao				AS 'Nome da turma',
count(aluno.co_aluno)		AS 'Nª de alunos'

FROM turma, aluno, aluno_turma

WHERE turma.co_turma = aluno_turma.co_turma
AND   aluno.co_aluno = aluno_turma.co_aluno

GROUP BY turma.descricao
ORDER BY count(aluno.co_aluno) DESC;

-- --------------------------------------------------------------------------------- --

-- EXERCICIO 11

SELECT
aluno.nome									AS 	'Nome do Alumo',
disciplina.no_disciplina					AS  'Disciplina',
FORMAT (AVG(avaliacao.nt_avaliacao), 1) 	AS  'Média Final' 
-- 'FORMAT' USADO PARA LIMITAR AS CASAS DECIMAIS
-- 'AVG' USADO PARA CALCULAR A MEDIA
-- WHERE (CLÁUSULA SQL QUE FILTRA LINHAS )
-- HAVING (CLÁUSULA SQL QUE FILTRA GRUPOS)

FROM aluno, aluno_turma, disciplina, avaliacao

WHERE aluno.co_aluno = aluno_turma.co_aluno
AND	  avaliacao.co_aluno = aluno_turma.co_aluno
AND	  avaliacao.co_turma = aluno_turma.co_turma
AND   disciplina.co_disciplina = avaliacao.co_disciplina
GROUP BY aluno.nome, disciplina.no_disciplina
HAVING AVG(avaliacao.nt_avaliacao) > (SELECT AVG(avaliacao.nt_avaliacao) FROM avaliacao) 
-- media de notas da faculdade
ORDER BY 1, 2, 3;

-- --------------------------------------------------------------------------------- --

SELECT COUNT(avaliacao.nt_avaliacao) FROM avaliacao;
SELECT SUM(avaliacao.nt_avaliacao) FROM avaliacao;

SELECT SUM(avaliacao.nt_avaliacao) /
 COUNT(avaliacao.nt_avaliacao)
 FROM avaliacao;

SELECT AVG(avaliacao.nt_avaliacao) FROM avaliacao;

-- --------------------------------------------------------------------------------- --
