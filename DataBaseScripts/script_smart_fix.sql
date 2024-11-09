CREATE DATABASE SMART_FIX;

USE SMART_FIX;


-- DDL - DEFININDO ESTRUTURA DE TABELAS
-- ----------------------------------------------------------------------------------------------------------
CREATE TABLE tb_classificacao (
    cla_id 		  INT AUTO_INCREMENT  NOT NULL UNIQUE,
    cla_nome 	  VARCHAR(20)         NOT NULL UNIQUE,
    
    PRIMARY KEY (cla_id)
);


CREATE TABLE tb_bloco (
    bl_id 		INT AUTO_INCREMENT  NOT NULL UNIQUE,
    bl_nome 	VARCHAR(20)         NULL UNIQUE,
    bl_departamento VARCHAR(20) 	NULL,
    
    PRIMARY KEY (bl_id)
);


CREATE TABLE tb_itens (
    itm_id 		INT AUTO_INCREMENT  NOT NULL UNIQUE,
    itm_nome 	VARCHAR(20)         NOT NULL UNIQUE,
    
    PRIMARY KEY (itm_id)
);


CREATE TABLE tb_administrador (
  adm_id      int(11)           NOT NULL,
  adm_nome    varchar(50)       DEFAULT NULL,
  adm_senha   varchar(100)      DEFAULT NULL,
  adm_status  smallint(6)       DEFAULT NULL,  
  PRIMARY KEY (adm_id)
);


CREATE TABLE tb_sala (
    sl_id 		  INT AUTO_INCREMENT  NOT NULL UNIQUE,
    sl_num 		  VARCHAR(10)         NOT NULL,
    bl_id 		  INT         		    NULL,
    
    PRIMARY KEY       (sl_id),
    KEY bl_nome_sala  (bl_id),
    CONSTRAINT tb_sala_ibfk_1 FOREIGN KEY (bl_id) 	REFERENCES 	tb_bloco(bl_id)
);


CREATE TABLE tb_maquina (
    maq_id 		  INT AUTO_INCREMENT  NOT NULL UNIQUE,
    maq_num 	  VARCHAR(10)         NOT NULL UNIQUE,
    sl_id     	INT                 NOT NULL, 
    bl_id       INT                 NOT NULL,
    PRIMARY KEY     (maq_id),
    KEY sl_id_maq  (sl_id),
    KEY bl_id_maq  (bl_id),
    CONSTRAINT tb_maquina_ibfk_1 FOREIGN KEY (sl_id) 	REFERENCES 	tb_sala(sl_id),
    CONSTRAINT tb_maquina_ibfk_2 FOREIGN KEY (bl_id) 	REFERENCES 	tb_bloco(bl_id)
);


CREATE TABLE tb_chamado (
  cha_id 		    int(11) 		  NOT NULL AUTO_INCREMENT,
  cha_dt_inicio date 			    NOT NULL,
  cla_id 		    int 			    NOT NULL,
  itm_id 		    int 			    NOT NULL,
  cha_assunto 	varchar(50) 	NOT NULL,
  maq_id 		    int 			    NOT NULL,
  sl_id 		    int 			    NOT NULL,
  bl_id 		    int 			    NOT NULL,
  cha_desc 		  varchar(300) 	DEFAULT NULL,
  cha_sit 		  varchar(20) 	NOT NULL DEFAULT 'Aberto',
  cha_dt_fim 	  date 			    DEFAULT NULL,
  cha_notes 	  varchar(300) 	DEFAULT NULL,
  
  PRIMARY KEY (cha_id),
  UNIQUE KEY 	cha_id 	(cha_id),
  KEY 			  cla_id 	(cla_id),
  KEY 			  itm_id 	(itm_id),
  KEY 			  maq_id 	(maq_id),
  KEY 			  sl_id 	(sl_id),
  KEY 			  bl_id 	(bl_id),
  CONSTRAINT tb_chamado_ibfk_1 FOREIGN KEY (cla_id) 	REFERENCES tb_classificacao (cla_id),
  CONSTRAINT tb_chamado_ibfk_2 FOREIGN KEY (itm_id) 	REFERENCES tb_itens         (itm_id),
  CONSTRAINT tb_chamado_ibfk_3 FOREIGN KEY (maq_id) 	REFERENCES tb_maquina       (maq_id),
  CONSTRAINT tb_chamado_ibfk_4 FOREIGN KEY (sl_id) 	  REFERENCES tb_sala          (sl_id),
  CONSTRAINT tb_chamado_ibfk_5 FOREIGN KEY (bl_id) 	  REFERENCES tb_bloco         (bl_id)
);

CREATE TABLE tb_usuario (
  user_id     INT               NOT NULL AUTO_INCREMENT,
  cha_id      INT               NOT NULL,
  user_email  varchar(100)      NOT NULL,
  PRIMARY KEY (user_id),
  CONSTRAINT tb_usuario_ibfk_1 FOREIGN KEY (cha_id) 	REFERENCES 	tb_chamado(cha_id)
);

-- DML - POPULANDO TABELAS
------------------------------------------------------------------------------------------------------------
INSERT INTO tb_classificacao (cla_nome)
VALUES  ('Problema'),
		('Instalação'), 
        ('Melhoria'), 
        ('Outros');                                 -- SELECT * FROM tb_classificacao ORDER BY cla_id;


INSERT INTO tb_itens (itm_nome)
VALUES 	('CPU'),
		('Monitor'),
        ('Mouse'),
        ('Teclado'),
        ('Som'),
        ('Internet'),
        ('Software');                               -- SELECT * FROM tb_itens ORDER BY itm_id;

INSERT INTO tb_bloco (bl_nome)
VALUES 	('A'),
		('B'),
        ('C'),
        ('D');                                     -- SELECT * FROM tb_bloco ORDER BY bl_id;
        
INSERT INTO tb_sala (sl_num, bl_id)
VALUES 	('10', 1),
		('11', 2),
        ('12', 3),
        ('13', 4);                                    -- SELECT * FROM tb_sala ORDER BY sl_id;

INSERT INTO tb_maquina (maq_num, sl_id, bl_id)
VALUES 	('0',   1, 1),
		('311', 1, 1),
        ('312', 2, 2),
        ('313', 2, 2),
        ('314', 3, 3),
        ('315', 3, 3),
        ('316', 4, 4);                                    -- SELECT * FROM tb_maquina ORDER BY maq_id;

INSERT INTO tb_administrador
            (adm_id,
            adm_nome,
            adm_senha,
            adm_status)
VALUES 
       (1,'Admin',
       MD5('AdminSistAcess123'),
       0);

-- ----------------------------------------------------------------------------------------
-- CRIANDO PROCEDURE

DELIMITER $$

CREATE PROCEDURE ComandosSmartFix(

  IN Action VARCHAR      (50),
  IN Cha_id       INT,
  IN Cha_Sit      VARCHAR(50),
  IN Cha_dt_fim   DATE,
  IN Cha_notes    VARCHAR(300),
  IN cla_nome     VARCHAR(20),
  IN itm_nome     VARCHAR(20),
  IN Cha_assunto  VARCHAR(50),
  IN maq_num      INT,
  IN sl_num       INT,
  IN bl_nome      VARCHAR(20),
  IN Cha_desc     VARCHAR(300),
  IN Bl_id        INT,
  IN Cl_id        INT,
  IN Itm_id       INT,
  IN Maq_id       INT,
  IN Sl_id        INT,
  IN bl_departamento VARCHAR(20),
  IN user_email VARCHAR(100)
)
BEGIN

  -- --------------------------------------------------------------------------------------------
  -- Actions referentes a tb_chamado
  
  IF Action = 'Update_TbCha' THEN

    UPDATE tb_chamado
       SET cha_sit     = Cha_Sit,
           cha_dt_fim  = Cha_dt_fim,
           cha_notes   = Cha_notes
     WHERE cha_id      = Cha_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Delete_TbCha' THEN
    
    DELETE FROM tb_chamado
          WHERE cha_id = Cha_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Insert_TbCha' THEN
    
    INSERT INTO tb_chamado 
                (cla_id,cha_dt_inicio, itm_id, cha_assunto, maq_id, sl_id, bl_id, cha_desc)           
          VALUES 
                (Cl_id, curdate(),Itm_id, Cha_assunto, Maq_id, Sl_id, Bl_id, Cha_desc);
	SET @cha_fk = LAST_INSERT_ID();
                
	INSERT INTO tb_usuario
		(cha_id, user_email)
	VALUES
        (@cha_fk,user_email);
        
  END IF;
-- ----------------------------------------------    
  IF Action = 'SelectId_TbCha' THEN
    
    SELECT * FROM tb_chamado
     WHERE cha_id = Cha_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectAll_TbCha' THEN
    
    SELECT * FROM tb_chamado;
  END IF;


  -- --------------------------------------------------------------------------------------------
  -- Actions referentes a tb_bloco
  
  IF Action = 'Update_TbBlo' THEN
    
    UPDATE tb_bloco
       SET bl_nome  = bl_nome,
		   bl_departamento = bl_departamento
     WHERE bl_id    = Bl_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Delete_TbBlo' THEN
    
    DELETE FROM tb_bloco
          WHERE bl_id = Bl_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Insert_TbBlo' THEN
    
    INSERT INTO tb_bloco (bl_nome, bl_departamento)
         VALUES (bl_nome,bl_departamento);
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectId_TbBlo' THEN
    
    SELECT * FROM tb_bloco
     WHERE bl_id = Bl_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectAll_TbBlo' THEN
    
    SELECT * FROM tb_bloco;
  END IF;

  -- --------------------------------------------------------------------------------------------
  -- Actions referentes a tb_classificacao

  IF Action = 'Update_TbCla' THEN

    UPDATE tb_classificacao
       SET cla_nome = cla_nome
     WHERE cla_id   = Cl_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Delete_TbCla' THEN

    DELETE FROM tb_classificacao
          WHERE cla_id = Cl_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Insert_TbCla' THEN

    INSERT INTO tb_classificacao (cla_nome)
         VALUES (cla_nome);
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectId_TbCla' THEN

    SELECT * FROM tb_classificacao
     WHERE cla_id = Cl_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectAll_TbCla' THEN

    SELECT * FROM tb_classificacao;
  END IF;

  -- --------------------------------------------------------------------------------------------
  -- Actions referentes a tb_itens
  
  IF Action = 'Update_TbItm' THEN

    UPDATE tb_itens
       SET itm_nome = itm_nome
     WHERE itm_id   = Itm_id;
  END IF;
-- ----------------------------------------------    
  IF Action = 'Delete_TbItm' THEN

    DELETE FROM tb_itens
          WHERE itm_id = Itm_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Insert_TbItm' THEN

    INSERT INTO tb_itens (itm_nome)
         VALUES (itm_nome);
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectId_TbItm' THEN

    SELECT * FROM tb_itens
     WHERE itm_id = Itm_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectAll_TbItm' THEN

    SELECT * FROM tb_itens;
  END IF;

  -- --------------------------------------------------------------------------------------------
  -- Actions referentes a tb_maquina
 
  IF Action = 'Update_TbMaq' THEN
 
    UPDATE tb_maquina
       SET maq_num  = maq_num,
		   sl_id    = Sl_id,
		   bl_id    = Bl_id
     WHERE maq_id   = Maq_id;
  END IF;
  -- ----------------------------------------------    
  IF Action = 'Delete_TbMaq' THEN
 
    DELETE FROM tb_maquina
          WHERE maq_id = Maq_id;
  END IF;
  -- ----------------------------------------------    

  IF Action = 'Insert_TbMaq' THEN
 
    INSERT INTO tb_maquina (maq_num, sl_id, bl_id)
         VALUES (maq_num, Sl_id, Bl_id);
  END IF;
  -- ----------------------------------------------    

  IF Action = 'SelectId_TbMaq' THEN
 
    SELECT * FROM tb_maquina
    WHERE maq_id = Maq_id;
  END IF;
  -- ----------------------------------------------    

  IF Action = 'SelectAll_TbMaq' THEN
 
    SELECT * FROM tb_maquina;
  END IF;
 
  -- --------------------------------------------------------------------------------------------
  -- Actions referentes a tb_sala
 
  IF Action = 'Update_TbSal' THEN
 
     UPDATE tb_sala
        SET sl_num = sl_num,
			bl_id = Bl_id
      WHERE sl_id = Sl_id;
  END IF;
  -- ----------------------------------------------    
  IF Action = 'Delete_TbSal' THEN
 
    DELETE FROM tb_sala
          WHERE sl_id = Sl_id;
  END IF;
  -- ----------------------------------------------    

  IF Action = 'Insert_TbSal' THEN
 
    INSERT INTO tb_sala (sl_num, bl_id)
         VALUES (sl_num, Bl_id);
  END IF;
  -- ----------------------------------------------    
  
  IF Action = 'SelectId_TbSal' THEN 
 
    SELECT * FROM tb_sala
            WHERE sl_id = Sl_id;  
  END IF;
  -- ----------------------------------------------    

  IF Action = 'SelectAll_TbSal' THEN
    SELECT * FROM tb_sala;
  END IF;

END $$

DELIMITER ;




-- --------------------------------------------------------------------------------------------
-- Chamando funções da PROCEDURE
-- OBSERVAÇÃO - COMANDO RODOU CERTO NO SQL DO PHPMYADMIN

CALL ComandosSmartFix (
'Update_TbCha'        , -- Action VARCHAR      (50),
1                     , -- Cha_id       INT,
'Em andamento'        , -- Cha_Sit      VARCHAR(50),
'2024-10-02'          , -- Cha_dt_fim   DATE,            
'Fase de testes'      , -- Cha_notes    VARCHAR(300),    
null                  , -- cla_nome     VARCHAR(20),
null                  , -- itm_nome     VARCHAR(20),
null                  , -- Cha_assunto  VARCHAR(50),
null                  , -- maq_num      INT,              
null                  , -- sl_num       INT,
null                  , -- bl_nome      VARCHAR(20),      
null                  , -- Cha_desc     VARCHAR(300),     -
null                  , -- Bl_id        INT,
null                  , -- Cl_id        INT,
null                  , -- Itm_id       INT,
null                  , -- Maq_id       INT,
null                   -- Sl_id        INT
);




-- LISTA DE OPÇÕES DE ACTION
--  'Update_TbCha'
--  'Delete_TbCha'
--  'Insert_TbCha'
--  'SelectId_TbCha'
--  'SelectAll_TbCha'
--  'Update_TbBlo'
--  'Delete_TbBlo'
--  'Insert_TbBlo'
--  'SelectId_TbBlo'
--  'SelectAll_TbBlo'
--  'Update_TbCla'
--  'Delete_TbCla'
--  'Insert_TbCla'
--  'SelectId_TbCla'
--  'SelectAll_TbCla'
--  'Update_TbItm'
--  'Delete_TbItm'
--  'Insert_TbItm'
--  'SelectId_TbItm'
--  'SelectAll_TbItm'
--  'Update_TbMaq'
--  'Delete_TbMaq'
--  'Insert_TbMaq'
--  'SelectId_TbMaq'
--  'SelectAll_TbMaq'
--  'Update_TbSal'
--  'Delete_TbSal'
--  'Insert_TbSal'
--  'SelectId_TbSal' 
--  'SelectAll_TbSal'

use smart_fix

DELIMITER $$
create procedure DDL(
IN Action int,
IN sala_id int,
IN bloco_id int
)
BEGIN

IF Action = 1 THEN
select bl_id ,bl_nome from tb_bloco;
end if;

If Action = 2 then
select itm_id, itm_nome from tb_itens;
end IF;

If Action = 3 then
select cla_id, cla_nome from tb_classificacao;
end IF;

If Action = 4 then
select maq_id, maq_num from tb_maquina
inner join tb_sala on
tb_sala.sl_id = tb_maquina.sl_id
where tb_maquina.sl_id = sala_id;
end IF;

If Action = 5 then
select sl_id, sl_num from tb_sala
inner join tb_bloco on
tb_bloco.bl_id = tb_sala.bl_id
where tb_sala.bl_id = bloco_id;
end IF;

END $$


DELIMITER $$
create procedure LOGIN(
IN Senha nvarchar(100), 
IN Nome varchar(50)
)
BEGIN

SELECT * 
FROM tb_administrador
WHERE adm_senha = MD5(Senha) and adm_nome = Nome and adm_status = 0; -- verifica login

END $$


-- ----------------------------------------------------------------------------------------
-- CRIANDO PROCEDURE GRAFANA
DELIMITER $$
create procedure GRAFANA(
IN Action  varchar(80)
)
BEGIN

IF Action = 'Chamados em Aberto' then
	select count(*) 
		from tb_chamado 
	where cha_sit = 'Aberto';
end if;
END $$