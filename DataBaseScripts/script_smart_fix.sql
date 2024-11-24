CREATE DATABASE SMART_FIX;

USE SMART_FIX;


-- ********************************************************************************************************
--                               DDL - DEFININDO ESTRUTURA DE TABELAS
-- ********************************************************************************************************
CREATE TABLE tb_classificacao (
    cla_id 		  INT AUTO_INCREMENT  NOT NULL UNIQUE,
    cla_nome 	  VARCHAR(20)         NOT NULL UNIQUE,
    
    PRIMARY KEY (cla_id)
);


CREATE TABLE tb_bloco (
    bl_id 		INT AUTO_INCREMENT  NOT NULL UNIQUE,
    bl_nome 	VARCHAR(20)         NULL UNIQUE,
    
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

-- ********************************************************************************************************
--                                       CRIANDO PROCEDURE
-- ********************************************************************************************************

-- LISTA DE OPÇÕES DE ACTION

--  'Update_TbCha'			Atualizar chamado
--  'Delete_TbCha'			Deletar chamado
--  'Insert_TbCha'			Inserir chamado
--  'SelectId_TbCha'		Buscar chamado pelo ID
--  'SelectAll_TbCha'		Buscar todos chamados
--  'Update_TbBlo'			Atualizar bloco
--  'Delete_TbBlo'			Deletar bloco
--  'Insert_TbBlo'			Inserir bloco
--  'SelectId_TbBlo'		Buscar bloco por ID
--  'Select_TbBlo'     Selecionar bloco com filtros
--  'SelectAll_TbBlo'       Buscar todos blocos
--  'Update_TbCla'			Atualizar classificação
--  'Delete_TbCla'			Deletar classificação
--  'Insert_TbCla'			Inserir classificação
--  'SelectId_TbCla'		Buscar classificação pelo ID
--  'SelectAll_TbCla'       Buscar todas classificações
--  'Update_TbItm'          Atualizar item
--  'Delete_TbItm'			Deletar item
--  'Insert_TbItm'			Inserir item
--  'SelectId_TbItm'		Buscar item pelo ID
--  'SelectAll_TbItm'		Buscar todos itens
--  'Update_TbMaq'			Atualizar maquina
--  'Delete_TbMaq'			Deletar máquina
--  'Insert_TbMaq'			Inserir máquina
--  'SelectId_TbMaq'		Buscar máquina pelo ID
--  'Select_TbMaq''     Selecionar máquina com filtros
--  'SelectAll_TbMaq'		Buscar todas máquinas
--  'Update_TbSal'			Atualizar sala
--  'Delete_TbSal'			Deletar sala
--  'Insert_TbSal'			Inserir sala
--  'SelectId_TbSal' 		Selecionar sala pelo ID
--  'Select_TbSal''     Selecionar sala com filtros
--  'SelectAll_TbSal'		Selecionar todas salas

DELIMITER $$

CREATE PROCEDURE ComandosSmartFix(

  IN Action VARCHAR      (50),
  IN P_Cha_id       INT,
  IN P_Cha_Sit      VARCHAR(50),
  IN P_Cha_dt_fim   DATE,
  IN P_Cha_notes    VARCHAR(300),
  IN P_cla_nome     VARCHAR(20),
  IN P_itm_nome     VARCHAR(20),
  IN P_Cha_assunto  VARCHAR(50),
  IN P_maq_num      INT,
  IN P_sl_num       INT,
  IN P_bl_nome      VARCHAR(20),
  IN P_Cha_desc     VARCHAR(300),
  IN P_Bl_id        INT,
  IN P_Cl_id        INT,
  IN P_Itm_id       INT,
  IN P_Maq_id       INT,
  IN P_Sl_id        INT,
  IN P_bl_departamento VARCHAR(20),
  IN P_user_email VARCHAR(100)
)
BEGIN

  -- --------------------------------------------------------------------------------------------
  -- Actions referentes a tb_chamado
  
  IF Action = 'Update_TbCha' THEN

    UPDATE tb_chamado
       SET cha_sit     = P_Cha_Sit,
           cha_dt_fim  = P_Cha_dt_fim,
           cha_notes   = P_Cha_notes
     WHERE cha_id      = P_Cha_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Delete_TbCha' THEN
    
    DELETE FROM tb_chamado
          WHERE cha_id = P_Cha_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Insert_TbCha' THEN
    
    INSERT INTO tb_chamado 
                (cla_id,cha_dt_inicio, itm_id, cha_assunto, maq_id, sl_id, bl_id, cha_desc)           
          VALUES 
                (P_Cl_id, curdate(),P_Itm_id, P_Cha_assunto, P_Maq_id, P_Sl_id, P_Bl_id, P_Cha_desc);
	SET @cha_fk = LAST_INSERT_ID();
                
	INSERT INTO tb_usuario
		(cha_id, user_email)
	VALUES
        (@cha_fk,P_user_email);
        
  END IF;
-- ----------------------------------------------    
  IF Action = 'SelectId_TbCha' THEN
    
    SELECT * FROM tb_chamado
     WHERE cha_id = P_Cha_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectAll_TbCha' THEN
    
    SELECT * FROM tb_chamado;
  END IF;


  -- --------------------------------------------------------------------------------------------
  -- Actions referentes a tb_bloco
  
  IF Action = 'Update_TbBlo' THEN
    
    IF NOT EXISTS(select * from tb_bloco where bl_nome = P_bl_nome) THEN
    UPDATE tb_bloco
       SET bl_nome  = P_bl_nome
     WHERE bl_id    = P_Bl_id;
    
	select * from tb_bloco where bl_id = P_Bl_id;
    ELSE
		select 'erro';
	END IF;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Delete_TbBlo' THEN
    
    DELETE FROM tb_bloco
          WHERE bl_id = P_Bl_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Insert_TbBlo' THEN
    
    IF NOT EXISTS(select * from tb_bloco where bl_nome = P_bl_nome) THEN
    INSERT INTO tb_bloco (bl_nome)
         VALUES (P_bl_nome);
	SET @P_bl_id = LAST_INSERT_ID();
    
    select * from tb_bloco where bl_id = @P_bl_id;
    ELSE
		select 'erro';
	END IF;
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectId_TbBlo' THEN
    
    SELECT * FROM tb_bloco
     WHERE bl_id = P_Bl_id;
  END IF;
-- ----------------------------------------------    

  -- ----------------------------------------------    
  
  IF Action = 'Select_TbBlo' THEN 
 
    SELECT bl_id, bl_nome FROM tb_bloco
            WHERE (1 = 1)
            AND ((P_bl_nome is null) or (bl_nome like CONCAT('%', P_bl_nome, '%')));
  END IF;
  -- ----------------------------------------------  
  
  IF Action = 'SelectAll_TbBlo' THEN
    
    SELECT * FROM tb_bloco;
  END IF;

  -- --------------------------------------------------------------------------------------------
  -- Actions referentes a tb_classificacao

  IF Action = 'Update_TbCla' THEN

    UPDATE tb_classificacao
       SET cla_nome = P_cla_nome
     WHERE cla_id   = P_Cl_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Delete_TbCla' THEN

    DELETE FROM tb_classificacao
          WHERE cla_id = P_Cl_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Insert_TbCla' THEN

    INSERT INTO tb_classificacao (cla_nome)
         VALUES (P_cla_nome);
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectId_TbCla' THEN

    SELECT * FROM tb_classificacao
     WHERE cla_id = P_Cl_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectAll_TbCla' THEN

    SELECT * FROM tb_classificacao;
  END IF;

  -- --------------------------------------------------------------------------------------------
  -- Actions referentes a tb_itens
  
  IF Action = 'Update_TbItm' THEN

    UPDATE tb_itens
       SET itm_nome = P_itm_nome
     WHERE itm_id   = P_Itm_id;
  END IF;
-- ----------------------------------------------    
  IF Action = 'Delete_TbItm' THEN

    DELETE FROM tb_itens
          WHERE itm_id = Itm_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'Insert_TbItm' THEN

    INSERT INTO tb_itens (itm_nome)
         VALUES (P_itm_nome);
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectId_TbItm' THEN

    SELECT * FROM tb_itens
     WHERE itm_id = P_Itm_id;
  END IF;
-- ----------------------------------------------    

  IF Action = 'SelectAll_TbItm' THEN

    SELECT * FROM tb_itens;
  END IF;

  -- --------------------------------------------------------------------------------------------
  -- Actions referentes a tb_maquina
 
  IF Action = 'Update_TbMaq' THEN
 
 IF NOT EXISTS(select * from tb_maquina where maq_num = P_maq_num and sl_id = P_Sl_id and bl_id = P_Bl_id) THEN
    UPDATE tb_maquina
       SET maq_num  = P_maq_num,
		   sl_id    = P_Sl_id,
		   bl_id    = P_Bl_id
     WHERE maq_id   = P_Maq_id;
    
	select * from tb_maquina where maq_id = P_Maq_id;
 ELSE
	SELECT 'erro';
   END IF;
  END IF;
  -- ----------------------------------------------    
  IF Action = 'Delete_TbMaq' THEN
 
    DELETE FROM tb_maquina
          WHERE maq_id = P_Maq_id;
  END IF;
  -- ----------------------------------------------    

  IF Action = 'Insert_TbMaq' THEN
 
 IF NOT EXISTS(select * from tb_maquina where maq_num = P_maq_num and sl_id = P_Sl_id and bl_id = P_Bl_id) THEN
    INSERT INTO tb_maquina (maq_num, sl_id, bl_id)
         VALUES (P_maq_num, P_Sl_id, P_Bl_id);
         
	SET @P_maq_id = LAST_INSERT_ID();
    
	select * from tb_maquina where maq_id = @P_maq_id;
 ELSE
	SELECT 'erro';
  END IF;
  END IF;
  -- ----------------------------------------------    

  IF Action = 'SelectId_TbMaq' THEN
 
    SELECT * FROM tb_maquina
    WHERE maq_id = P_Maq_id;
  END IF;
  -- ----------------------------------------------    

 -- ----------------------------------------------    
  
  IF Action = 'Select_TbMaq' THEN 
 
    SELECT maq_id, maq_num, sl_num, bl_nome, tb_maquina.sl_id, tb_maquina.bl_id FROM tb_maquina
    inner join tb_bloco on
		tb_bloco.bl_id = tb_maquina.bl_id
	inner join tb_sala on
		tb_sala.sl_id = tb_maquina.sl_id
            WHERE (1 = 1)
            AND ((P_maq_num is null) or (maq_num like CONCAT('%',P_maq_num,'%')))
            AND ((P_Sl_id is null) or (tb_maquina.sl_id = P_Sl_id))
            AND ((P_Bl_id is null) or  (tb_maquina.bl_id = P_Bl_id));
  END IF;
  -- ----------------------------------------------    
  
  IF Action = 'SelectAll_TbMaq' THEN
 
    SELECT * FROM tb_maquina;
  END IF;
 
  -- --------------------------------------------------------------------------------------------
  -- Actions referentes a tb_sala
 
  IF Action = 'Update_TbSal' THEN
 
 IF NOT EXISTS(select * from tb_sala where sl_num = P_sl_num and bl_id = P_Bl_id) THEN
     UPDATE tb_sala
        SET sl_num = P_sl_num,
			bl_id = P_Bl_id
      WHERE sl_id = P_Sl_id;
    
	select * from tb_sala where sl_id = P_Sl_id;
    ELSE 
		SELECT 'erro';
	END IF;
  END IF;
  -- ----------------------------------------------    
  IF Action = 'Delete_TbSal' THEN
 
    DELETE FROM tb_sala
          WHERE sl_id = P_Sl_id;
  END IF;
  -- ----------------------------------------------    

  IF Action = 'Insert_TbSal' THEN
 
 IF NOT EXISTS(select * from tb_sala where sl_num = P_sl_num and bl_id = P_Bl_id) THEN
    INSERT INTO tb_sala (sl_num, bl_id)
         VALUES (P_sl_num, P_Bl_id);
         
	SET @P_sl_id = LAST_INSERT_ID();
    
    select * from tb_sala where sl_id = @P_sl_id;
	ELSE 
		SELECT 'erro';
	END IF;
  END IF;
  -- ----------------------------------------------    
  
  IF Action = 'SelectId_TbSal' THEN 
 
    SELECT * FROM tb_sala
            WHERE sl_id = P_Sl_id;  
  END IF;
  -- ---------------------------------------------- 
  
  -- ----------------------------------------------    
  
  IF Action = 'Select_TbSal' THEN 
 
    SELECT sl_id, sl_num, bl_nome, tb_sala.bl_id FROM tb_sala
    inner join tb_bloco on
		tb_bloco.bl_id = tb_sala.bl_id
            WHERE (1 = 1)
            AND ((P_sl_num is null) or (sl_num = P_sl_num))
            AND ((P_Bl_id is null) or  (tb_sala.bl_id = P_Bl_id));
  END IF;
  -- ----------------------------------------------    
  
  IF Action = 'SelectAll_TbSal' THEN
    SELECT * FROM tb_sala;
  END IF;

END $$

DELIMITER ;

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


-- ********************************************************************************************************
--                                       DML - POPULANDO TABELAS
-- ********************************************************************************************************

INSERT INTO tb_bloco (bl_nome)
VALUES 	('Bloco A'      ),
		('Bloco B'      ),
        ('Bloco C'      ),
        ('Bloco D'      ),
        ('Dpto. Adm.'   ),
        ('Dpto. RH'     ),
        ('Dpto.Financ.' );                           -- SELECT * FROM tb_bloco ORDER BY bl_id;
        
        
INSERT INTO tb_sala (sl_num, bl_id)
VALUES 	('10A', 1),
	    ('11', 2),
        ('12', 3),
        ('13', 4);                                    -- SELECT * FROM tb_sala ORDER BY sl_id;


INSERT INTO tb_maquina (maq_num, sl_id, bl_id)
VALUES 	('0',   1, 1),
		('BAR-311', 1, 1),
        ('312', 2, 2),
        ('313', 2, 2),
        ('314', 3, 3),
        ('315', 3, 3),
        ('316', 4, 4);                                    -- SELECT * FROM tb_maquina ORDER BY maq_id;


INSERT INTO tb_classificacao (cla_nome)
VALUES  ('Problema'),
		('Instalação'), 
        ('Melhoria'), 
        ('Outros');                                 -- SELECT * FROM tb_classificacao ORDER BY cla_id;


INSERT INTO tb_itens (itm_nome)
VALUES 	('CPU'      ),
		('Monitor'  ),
        ('Mouse'    ),
        ('Teclado'  ),
        ('Som'      ),
        ('Internet' ),
        ('Software' ),
        ('Outros'   );                                -- SELECT * FROM tb_itens ORDER BY itm_id;


INSERT INTO tb_administrador
            (adm_id, adm_nome, adm_senha, adm_status)
VALUES 
       (1,'Admin' , MD5('AdminSistAcess123' ), 0),
       (2,'Thiago', MD5('2222'              ), 0);
       
-- --------------------------------------------------------------------------------------------
-- Chamando funções da PROCEDURE


-- Necessário DESATIVAR o modo seguro no Workbench em: Edit / Preferences / SQL Editor / Safe Updates

CALL ComandosSmartFix (
'Update_TbCha'        , -- 01 Action       VARCHAR      (50),
1                     , -- 02 Cha_id       INT,
'JOIA'        , -- 03 Cha_Sit      VARCHAR(50),
'2024-11-14'          , -- 04 Cha_dt_fim   DATE,            
'Fase de testes'      , -- 05 Cha_notes    VARCHAR(300),    
null                  , -- 06 cla_nome     VARCHAR(20),
null                  , -- 07 itm_nome     VARCHAR(20),
null                  , -- 08 Cha_assunto  VARCHAR(50),
null                  , -- 09 maq_num      INT,              
null                  , -- 10 sl_num       INT,
null                  , -- 11 bl_nome      VARCHAR(20),      
null                  , -- 12 Cha_desc     VARCHAR(300),     -
null                  , -- 13 Bl_id        INT,
null                  , -- 14 Cl_id        INT,
null                  , -- 15 Itm_id       INT,
null                  , -- 16 Maq_id       INT,
null                  , -- 17 Sl_id        INT
null 	   	            -- 18 user_email  	VARCHAR(100)
);

select * from tb_chamado







-- Precisa excluir primeiro o chamado vinculado na tabela usuário

DELETE FROM tb_usuario WHERE cha_id = 1

CALL ComandosSmartFix (
'Delete_TbCha'        , -- 01 Action       VARCHAR      (50),
9                   , -- 02 Cha_id       INT,
null			      , -- 03 Cha_Sit      VARCHAR(50),
null		          , -- 04 Cha_dt_fim   DATE,            
null			      , -- 05 Cha_notes    VARCHAR(300),    
null                  , -- 06 cla_nome     VARCHAR(20),
null                  , -- 07 itm_nome     VARCHAR(20),
null                  , -- 08 Cha_assunto  VARCHAR(50),
null                  , -- 09 maq_num      INT,              
null                  , -- 10 sl_num       INT,
null                  , -- 11 bl_nome      VARCHAR(20),      
null                  , -- 12 Cha_desc     VARCHAR(300),     -
null                  , -- 13 Bl_id        INT,
null                  , -- 14 Cl_id        INT,
null                  , -- 15 Itm_id       INT,
null                  , -- 16 Maq_id       INT,
null                  , -- 17 Sl_id        INT
null 	   	            -- 18 user_email  	VARCHAR(100)
);

