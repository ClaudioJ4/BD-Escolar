--Criando as tabelas
CREATE TABLE candidatos (
	Cpf bigint PRIMARY KEY,
	nome varchar(50),
	estado varchar,
	nascimento bigint,
	sexo smallint,
	curso varchar(50),
	nota int
);

CREATE TABLE notas_enem (
	Cpf bigint NOT NULL REFERENCES candidatos(Cpf) ON DELETE CASCADE,
	nota int
);

-- Tabela da relação entre os CPF's das duas tabelas
SELECT candidatos.cpf, candidatos.nome, candidatos.curso, notas_enem.nota
FROM candidatos
INNER JOIN notas_enem ON candidatos.cpf = notas_enem.cpf;

-- Alunos com as melhores notas de cada curso
;WITH CTE AS (

SELECT Cpf, nome, Curso, nota,
       ROW_NUMBER() OVER(PARTITION BY Curso ORDER BY nota DESC) as rnk
FROM candidatos
)

SELECT Cpf, nome, Curso, nota
FROM CTE
WHERE rnk <=1;

-- Todos os Alunos que passaram por curso
;WITH CTE AS (

SELECT Cpf, nome, Curso, nota,
       ROW_NUMBER() OVER(PARTITION BY Curso ORDER BY nota DESC) as rnk
FROM candidatos
)

SELECT Cpf, nome, Curso, nota
FROM CTE
WHERE rnk <=25;

-- Porcentagem de sexo (1 = Homem; 0 = Mulher)
SELECT Sexo, (Count(Sexo)* 100 / (SELECT Count(*) FROM Candidatos)) as Porcentagem
FROM candidatos
GROUP BY Sexo;

-- Retirando o curso de todos os alunos que não passaram na nota de corte
UPDATE candidatos
SET curso = NULL
WHERE nota < 978;

-- Deletando os Alunos que não passaram na nota de corte
DELETE FROM candidatos
WHERE nota < 978;
