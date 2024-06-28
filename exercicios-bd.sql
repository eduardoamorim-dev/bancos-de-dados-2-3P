-- Lista Exercício - Junções, funções agregadas, order by e having (Parte 1)


create database if not exists BDEmpresa;
use BDEmpresa;

CREATE TABLE Departamento (
    ID_Depto    NUMERIC(2)    NOT NULL,
    NomeDepto   VARCHAR(30)   NOT NULL,
    ID_Gerente  NUMERIC(4)      NOT NULL,
    CONSTRAINT pk_depto PRIMARY KEY (ID_Depto),
    CONSTRAINT uk_nome UNIQUE (NomeDepto)
);

CREATE TABLE Funcionario (
    ID_Func     NUMERIC(4)     NOT NULL,
    NomeFunc    VARCHAR(30)  NOT NULL,
    Endereco    VARCHAR(50)  NOT NULL,
    DataNasc    DATE          NOT NULL,
    Sexo        CHAR(1)       NOT NULL,
    Salario     NUMERIC(8,2)   NOT NULL,
    ID_Superv   NUMERIC(4)         NULL,
    ID_Depto    NUMERIC(2)     NOT NULL,
    CONSTRAINT pk_func PRIMARY KEY (ID_Func),
    CONSTRAINT ck_sexo CHECK (Sexo='M' or Sexo='F')
);

CREATE TABLE Projeto (
    ID_Proj       NUMERIC(4)     NOT NULL,
    NomeProj      VARCHAR(30)  NOT NULL,
    Localizacao   VARCHAR(30)      NULL,
    ID_Depto      NUMERIC(2)     NOT NULL,
    CONSTRAINT pk_proj PRIMARY KEY (ID_Proj),
    CONSTRAINT uk_nomeProj UNIQUE (NomeProj)
);

CREATE TABLE Dependente (
    ID_Dep       NUMERIC(6)     NOT NULL,
    ID_Func      NUMERIC(4)     NOT NULL,
    NomeDep      VARCHAR(30)  NOT NULL,
    DataNasc     DATE          NOT NULL,
    Sexo         CHAR(1)       NOT NULL,
    Parentesco   CHAR(15)          NULL,
    CONSTRAINT pk_depend PRIMARY KEY (ID_Dep, ID_Func),
    CONSTRAINT ck_sexo_dep CHECK (Sexo='M' or Sexo='F')
);

CREATE TABLE Trabalha (
    ID_Func    NUMERIC(4)     NOT NULL,
    ID_Proj    NUMERIC(4)     NOT NULL,
    NumHoras   NUMERIC(6,1)       NULL,
    CONSTRAINT pk_trab PRIMARY KEY (ID_Func,ID_Proj)
);

INSERT INTO Funcionario
VALUES (1,'Joao Silva','R. Guaicui, 175', str_to_date('01/02/1955',"%d/%m/%Y"),'M',500,2,1);
INSERT INTO Funcionario
VALUES (2,'Frank Santos','R. Gentios, 22',str_to_date('02/02/1966',"%d/%m/%Y"),'M',1000,8,1);
INSERT INTO Funcionario
VALUES (3,'Alice Pereira','R. Curitiba, 11',str_to_date('15/05/1970',"%d/%m/%Y"),'F',700,4,3);
INSERT INTO Funcionario
VALUES (4,'Junia Mendes','R. Espirito Santos, 123',str_to_date('06/07/1976',"%d/%m/%Y"),'F',1200,8,3);
INSERT INTO Funcionario
VALUES (5,'Jose Tavares','R. Irai, 153',str_to_date('07/10/1975',"%d/%m/%Y"),'M',1500,2,1);
INSERT INTO Funcionario
VALUES (6,'Luciana Santos','R. Irai, 175',str_to_date('07/10/1960',"%d/%m/%Y"),'F',600,2,1);
INSERT INTO Funcionario
VALUES (7,'Maria Ramos','R. C. Linhares, 10',str_to_date('01/11/1965',"%d/%m/%Y"),'F',1000,4,3);
INSERT INTO Funcionario
VALUES (8,'Jaime Mendes','R. Bahia, 111',str_to_date('25/11/1960',"%d/%m/%Y"),'M',2000,NULL,2);

INSERT INTO Departamento
VALUES (1,'Pesquisa',2);
INSERT INTO Departamento
VALUES (2,'Administracao',8);
INSERT INTO Departamento
VALUES (3,'Construcao',4);

INSERT INTO Dependente
VALUES (1,2,'Luciana',str_to_date('05/11/1990',"%d/%m/%Y"),'F','Filha');
INSERT INTO Dependente
VALUES (2,2,'Paulo',str_to_date('11/11/1992',"%d/%m/%Y"),'M','Filho');
INSERT INTO Dependente
VALUES (3,2,'Sandra',str_to_date('05/12/1996',"%d/%m/%Y"),'F','Filha');
INSERT INTO Dependente
VALUES (4,4,'Mike',str_to_date('05/11/1997',"%d/%m/%Y"),'M','Filho');
INSERT INTO Dependente
VALUES (5,1,'Max',str_to_date('11/05/1979',"%d/%m/%Y"),'M','Filho');
INSERT INTO Dependente
VALUES (6,1,'Rita',str_to_date('07/11/1985',"%d/%m/%Y"),'F','Filha');
INSERT INTO Dependente
VALUES (7,1,'Bety',str_to_date('15/12/1960',"%d/%m/%Y"),'F','Esposa');

INSERT INTO Projeto
VALUES (1,'ProdX','Savassi',1);
INSERT INTO Projeto
VALUES (2,'ProdY','Luxemburgo',1);
INSERT INTO Projeto
VALUES (3,'ProdZ','Centro',1);
INSERT INTO Projeto
VALUES (10,'Computacao','C. Nova',3);
INSERT INTO Projeto
VALUES (20,'Organizacao','Luxemburgo',2);
INSERT INTO Projeto
VALUES (30,'N. Beneficios','C. Nova',1);

INSERT INTO Trabalha
VALUES (1,1,32.5);
INSERT INTO Trabalha
VALUES (1,2,7.5);
INSERT INTO Trabalha
VALUES (5,3,40.0);
INSERT INTO Trabalha
VALUES (6,1,20.0);
INSERT INTO Trabalha
VALUES (6,2,20.0);
INSERT INTO Trabalha
VALUES (2,2,10.0);
INSERT INTO Trabalha
VALUES (2,3,10.0);
INSERT INTO Trabalha
VALUES (2,10,10.0);
INSERT INTO Trabalha
VALUES (2,20,10.0);
INSERT INTO Trabalha
VALUES (3,30,30.0);
INSERT INTO Trabalha
VALUES (3,10,10.0);
INSERT INTO Trabalha
VALUES (7,10,35.0);
INSERT INTO Trabalha
VALUES (7,30,5.0);
INSERT INTO Trabalha
VALUES (4,20,15.0);
INSERT INTO Trabalha
VALUES (8,20,NULL);

ALTER TABLE Funcionario
ADD CONSTRAINT fk_func_depto FOREIGN KEY (ID_Depto) REFERENCES Departamento (ID_Depto);

ALTER TABLE Funcionario
ADD CONSTRAINT fk_func_superv FOREIGN KEY (ID_Superv) REFERENCES Funcionario (ID_Func);

ALTER TABLE Departamento
ADD CONSTRAINT fk_depto_func FOREIGN KEY (ID_Gerente) REFERENCES Funcionario (ID_Func);

ALTER TABLE Projeto
ADD CONSTRAINT fk_proj_depto FOREIGN KEY (ID_Depto) REFERENCES Departamento (ID_Depto);

ALTER TABLE Dependente
ADD CONSTRAINT fk_dep_func FOREIGN KEY (ID_Func) REFERENCES Funcionario (ID_Func) ON DELETE CASCADE;

ALTER TABLE Trabalha
ADD CONSTRAINT fk_trab_func FOREIGN KEY (ID_Func) REFERENCES Funcionario (ID_Func) ON DELETE CASCADE;

ALTER TABLE Trabalha
ADD CONSTRAINT fk_trab_proj FOREIGN KEY (ID_Proj) REFERENCES Projeto (ID_Proj) ON DELETE CASCADE;


SELECT * FROM departamento;

-- 1. Insira na tabela de projeto o projeto “Novo Projeto”, localizado no “Buritis”, associando ao departamento 1.

INSERT INTO projeto
value(40, 'Novo Projeto', 'Buritis', 1);

-- 2. Insira na tabela de funcionários o funcionário 'Edgar Marinho', que mora na rua 'R. Alameda, 111', nascido em '13/11/1959', ganha R$ 2000,00, não tem supervisor e está a associado ao departamento 2;

INSERT INTO Funcionario
VALUES (10,'Edgar Marinho','R. Alameda, 111',str_to_date('13/11/1959',"%d/%m/%Y"),'M',2000,NULL,2);

-- 3. Atualize o salário do funcionário ‘Joao Silva’ para R$ 1000,00.

UPDATE funcionario 
SET Salario = 1500
WHERE NomeFunc = "Joao Silva";

-- 4. Liste o nome dos empregados do departamento 3 e também do 2 que possuem salário entre R$800,00 e R$1.200,00.

SELECT NomeFunc, Salario, ID_Func
FROM funcionario 
WHERE (Salario >= 800 AND Salario <= 1200)
AND (ID_Depto = 3 OR ID_Depto = 2);

-- 5. Liste o nome e o endereço de todos os empregados que pertencem ao departamento 'Pesquisa'.

SELECT f.NomeFunc, f.Endereco
FROM funcionario f
JOIN departamento d ON f.ID_Depto = d.ID_Depto
WHERE d.NomeDepto = 'Pesquisa'; 

-- 6. Liste o nome e a data de nascimento do empregado 'Joao Silva'. Mostre no formato brasileiro com dois dígitos no ano. (pesquise a função date_format)


-- 7. Liste o nome dos empregados que não possuem supervisores.
-- 8. Liste o nome dos empregados, o nome dos seus departamentos e o nome dos projetos em que eles trabalham, ordenados pelo departamento e pelo nome do projeto.
-- 9. Liste a soma, a média, o maior e o menor salário de todos os empregados.
-- 10. Liste a soma, a média, o maior e o menor salário dos empregados do departamento 'Pesquisa'.
-- 11. Liste o nome dos funcionários que não tem dependentes.
-- 12. Para cada projeto localizado no 'Luxemburgo', liste o numero do projeto, o número do departamento que o controla e o nome, endereço e data de aniversário do gerente do departamento.
-- 13. Liste o nome e localização dos projetos que não tem funcionários trabalhando neles.
-- 14. Liste o nome dos funcionários que não tem dependentes e não estejam trabalhando em nenhum projeto.
-- 15. Liste para cada empregado, o seu nome e o nome de seu supervisor.
-- 16. Liste o nome de cada projeto com o número de empregados que trabalham no projeto.
-- 17. Para cada projeto que possua mais de 2 empregados na equipe, liste o nome do projeto e a quantidade de empregados que trabalham no mesmo.,
-- 18. Para cada departamento que possua mais do que 2 empregados, liste o nome do departamento e o nome dos empregados que ganham mais do que 800,00.


