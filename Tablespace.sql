-- Descobrindo Tablespaces, Datafiles com espaço ocupado x livre no Oracle Database
SELECT df.tablespace_name "Tablespace",
  totalusedspace "Used MB",
  (df.totalspace - tu.totalusedspace) "Free MB",
  df.totalspace "Total MB",
  ROUND(100 * ( (df.totalspace - tu.totalusedspace)/ df.totalspace)) "% Free"
FROM
  (SELECT tablespace_name,
    ROUND(SUM(bytes) / 1048576) TotalSpace
  FROM dba_data_files
  GROUP BY tablespace_name
  ) df,
  (SELECT ROUND(SUM(bytes)/(1024*1024)) totalusedspace,
    tablespace_name
  FROM dba_segments
  GROUP BY tablespace_name
  ) tu
WHERE df.tablespace_name = tu.tablespace_name;

-------------------------------------------------------------------
-- Exibe Datafiles e Tablespaces de um banco de dados Oracle
SELECT  FILE_NAME, BLOCKS, TABLESPACE_NAME FROM DBA_DATA_FILES;

--------------------------------------------------------------------
-- Criando Tablespace e Datafile para Aplicação / Usuário
-- Primeira Tablespace e Datafile
CREATE TABLESPACE 
TBS_WEBMUNDI 
DATAFILE 'TBS_WEBMUNDI_DATA.dbf' SIZE 1M ONLINE;

-- Segunda Tablespace e Datafile
CREATE TABLESPACE 
TBS_WEBMUNDI2 
DATAFILE 'TBS_WEBMUNDI_DATA2.dbf' SIZE 1M ONLINE;

-- Criação de tabela TB_CLIENTE na Tablespace TBS_WEBMUNDI
CREATE TABLE TB_CLIENTE
(
CODIGO NUMBER(8),
NOME VARCHAR2(50)
)TABLESPACE TBS_WEBMUNDI ;

-- Exibindo dados da tabela Criada
desc TB_CLIENTE;

--------------------------------------------------------------
-- Listando tabelas contidas na Tablespace TBS_WEBMUNDI
SELECT TABLESPACE_NAME, TABLE_NAME  
FROM  DBA_TABLES  WHERE TABLESPACE_NAME= 'TBS_WEBMUNDI';

--------------------------------------------------------------
-- Descobrindo em que Tablespace esta uma determinada tabela
SELECT  TABLE_NAME, TABLESPACE_NAME FROM  DBA_TABLES 
WHERE TABLE_NAME = 'TB_CLIENTE';

--------------------------------------------------------------
-- Movimentando uma tabela de uma Tablespace para outra
ALTER TABLE TB_CLIENTE 
MOVE TABLESPACE 
TBS_WEBMUNDI2;

-- Checando a mudança de Tablespace
SELECT  TABLE_NAME, TABLESPACE_NAME FROM  DBA_TABLES 
WHERE TABLE_NAME = 'TB_CLIENTE';

--------------------------------------------------------------
-- Renomeando uma Tablespace
ALTER TABLESPACE 
TBS_WEBMUNDI2 
RENAME TO TBS_WEBMUNDI_PRINCIPAL;

--------------------------------------------------------------
-- Apagando as Tablespaces Criadas
DROP TABLESPACE TBS_WEBMUNDI
   INCLUDING CONTENTS AND DATAFILES;
   
DROP TABLESPACE TBS_WEBMUNDI_PRINCIPAL
   INCLUDING CONTENTS AND DATAFILES;   
