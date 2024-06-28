/*CREATE DATABASE pph01
    WITH
    OWNER = postgres
    ENCODING = 'UTF8';
*/

DROP TABLE IF EXISTS F_CSMO_EE_MSAL;
DROP TABLE IF EXISTS F_ETDC;
DROP TABLE IF EXISTS D_CLSS_SOCL;
DROP TABLE IF EXISTS D_DT_MES;
DROP TABLE IF EXISTS D_MNCP;
DROP TABLE IF EXISTS D_DMCL;
DROP TABLE IF EXISTS D_CTZC;
DROP TABLE IF EXISTS D_ETDC;
DROP TABLE IF EXISTS D_FRQC_USO_ETDC;
DROP TABLE IF EXISTS D_HRAR_USO;

-- Dimensão classe social
CREATE TABLE D_CLSS_SOCL(
	ID_CLSS_SOCL SERIAL PRIMARY KEY,  -- Id classe social
	CLSS_SOCL VARCHAR(5) NOT NULL     -- Classe social
);

-- Dimensão Tempo Mes
CREATE TABLE D_DT_MES(
	ID_DT_MES SERIAL PRIMARY KEY, -- Id Tempo Mes
	DT_MES VARCHAR(10) NOT NULL   -- Tempo Mes
);

--Dimensão Municipio
CREATE TABLE D_MNCP(
	ID_MNCP SERIAL PRIMARY KEY,     -- Id Municipio
	NM_REGI VARCHAR(15) NOT NULL,   -- Nome Regiao
	SG_UF VARCHAR(2) NOT NULL,      -- Sigla UF
	NM_MNCP VARCHAR(50) NOT NULL    -- Nome Municipio
);

-- Dimensão Domicilio
CREATE TABLE D_DMCL(
	ID_DMCL SERIAL PRIMARY KEY,        -- Id Domicilio
	QT_BANR INT,                       -- Quantidade banheiros
	QT_ATMV INT,					   -- Quantidade automoveis
	QT_MOTO INT,					   -- Quantidade Motocicletas
	TIPO_FONTE_AGUA VARCHAR(30), 	   -- Tipo fonte de agua
	TIPO_PVMT_RUA VARCHAR(30), 		   -- Tipo pavimento rua
	NU_MRDR INT,					   -- Numero Moradores
	TIPO_DMCL VARCHAR(20), 			   -- Tipo Domicilio
	COR_PDMN_PRDE_EXTN VARCHAR(10),    -- Cor Predominante parede externa
	ORNT_MRIA_JNLA VARCHAR(36),        -- Orientacao Maioria Janelas
	JNLA_VRAS_PRDE VARCHAR(25),        -- Janela Varias Paredes
	AR_DMCL_M2 FLOAT,                  -- Area domicilio metros quadrados
	MTRL_PDMN_PRDE_EXTN VARCHAR(40),   -- Material Predominante parede externa
	MTRL_PDMN_TLHD VARCHAR(30),        -- Material Predominante Telhado
	ORIG_EE_DMCL VARCHAR(65),          -- Origem Energia Eletrica Domicilio
	FONTE_PROP_GERC_EE VARCHAR(25),    -- Fonte Propia Geracao Energia eletrica
	TIPO_ATVD_DMCL VARCHAR(30)         -- Tipo atividade Domicilio
);

-- Dimensao Conscientizacao
CREATE TABLE D_CTZC(
	ID_CTZC SERIAL PRIMARY KEY,                    -- Id Conscientizacao
	ECLD_CHEFE_FMLA VARCHAR(55),                   -- Escolaridade Chefe da Familia
	PRFR_EQPT_CSMR_MENOS_EE VARCHAR(15),           -- Prefere equipamentos consumem menos energia eletrica
	DSLG_TV_QUND_N_ESTA_USDO VARCHAR(15),          -- Desligo a TV quando não esta usando
	EVITA_EQPT_SB VARCHAR(15),                     -- Evitar equipamentos em Stand By
	PORTA_JNLA_FCDO_USAR_ARCD VARCHAR(15),         -- Portas e janelas fechadas ao usar ar-condicionado
	DSLG_ARCD_QUND_FORA_ABTE VARCHAR(15),          -- Desligo o ar-condicionado quando estou fora do ambiente
	EVITA_LONGO_BANHO_CE VARCHAR(15),              -- Evita longos banhos no chuveiro eletrico
	USA_CE_POSC_VERAO_ECNZ_EE VARCHAR(15),         -- Usa chuveiro eletrico posicao versão para economizar energia eletrica
	EVITA_GLDR_ABTA VARCHAR(15),                   -- Evita geladeira aberta
	N_GUAD_ALMT_QENT_E_DSTD_GLDR VARCHAR(15),      -- Não guarda alimento quente e destampado na geladeira
	RGLR_TMTT_GLDR_CFRM_ETAC VARCHAR(15),          -- Regula Termostato Geladeria conforme estações
	N_SECA_ROUPA_GLDR VARCHAR(15),                 -- Não Seca Roupa na Galadeira (atrás da geladeira)
	MNTM_BRCH_GLDR_BOM_ESTD VARCHAR(15),           -- Mantem borracha geladeira em bom estado
	USAR_MDL_SMNT_QUND_CPCD_MAXM VARCHAR(15),      -- Usa maquina de lavar somente quando capacidade máxima
	ACML_ROUPA_PSSR VARCHAR(15),                   -- Acumula roupa para passar
	DSLG_FP_QUND_ENCR_SVCO VARCHAR(15),            -- Desliga o ferro de passar quando encerra o serviço
	USAR_TMPR_IDCA_TCDO_FP VARCHAR(15),	           -- Usa temperatura indicada tecido ferro de passar
	PRFR_LMPD_LED_FRCT VARCHAR(15),                -- Prefere lampadas led ou fluorescente
	EVITA_LIGAR_LMPD_DRTE_DIA VARCHAR(15),         -- Evita ligar lampadas durantes o dia
	DSLG_LMPD_ABTE_DCPD VARCHAR(15),               -- Desligo lampada em ambientes desocupados
	ELMN_PBLM_ITLC_ELTC VARCHAR(15),               -- Elimna Problemas na Instalacao Elétrica
	RCBE_INFO_ECNZ_EE VARCHAR(25),                 -- Recebe Informacoes sobre Economizar Energia Elétrica
	GTRA_RCBR_INFO_ECNZ_EE VARCHAR(25)             -- Gostaria de receber informacoes sobre economizar Energia Elétrica
);


-- Fato Consumo Energia Eletrica
CREATE TABLE F_CSMO_EE_MSAL(
	ID_F_CSMO_EE_MSAL SERIAL PRIMARY KEY,      -- Id Fato consumo energia eletrica mensal
	ID_CTZC INT,                   		    -- FK
	ID_DMCL INT,                   		    -- FK
	ID_CLSS_SOCL INT,                          -- FK
	ID_MNCP INT,                   		    -- FK
	ID_DT_MES INT,                   	        -- FK
	NU_CSMO_EE_MSAL_KWH FLOAT,                 -- Numero Consumo Energia Eletrica Mensal kW/h
	FOREIGN KEY(ID_CTZC) REFERENCES D_CTZC(ID_CTZC) ON DELETE CASCADE,
	FOREIGN KEY(ID_DMCL) REFERENCES D_DMCL(ID_DMCL) ON DELETE CASCADE,
	FOREIGN KEY(ID_CLSS_SOCL) REFERENCES D_CLSS_SOCL(ID_CLSS_SOCL) ON DELETE CASCADE,
	FOREIGN KEY(ID_MNCP) REFERENCES D_MNCP(ID_MNCP) ON DELETE CASCADE,
	FOREIGN KEY(ID_DT_MES) REFERENCES D_DT_MES(ID_DT_MES) ON DELETE CASCADE
);

-- Dimensão Eletrodomestico
CREATE TABLE D_ETDC(
	ID_ETDC SERIAL PRIMARY KEY,         -- Id Eletrodoméstico
	NM_ETDC VARCHAR(100)                -- Nome Eletrodoméstico
);  

-- Dimensão Frequencia de Uso Eletrodoméstico.
CREATE TABLE D_FRQC_USO_ETDC(
	ID_FRQC_USO_ETDC SERIAL PRIMARY KEY,       -- Id Frequencia Uso eletrodomestico
	FRQC_USO VARCHAR(50)                       -- Frequencia Uso 
);

-- Dimensao Horario de Uso 1 para usa, 0 não usa, NULL para não se aplica
CREATE TABLE D_HRAR_USO(
	ID_HRAR_USO SERIAL PRIMARY KEY,   -- Id Horario de Uso
	NA  SMALLINT,                      -- Não se aplica. 1 quando o Eletrodomestico teve informações de HRAR_USO coletadas
	USO_EVTL SMALLINT,                     -- Uso Eventual 
	HR_00 SMALLINT,						   -- Hora 00 a 01
	HR_01 SMALLINT,                        -- Hora 01 a 02
	HR_02 SMALLINT,
	HR_03 SMALLINT,
	HR_04 SMALLINT,
	HR_05 SMALLINT,
	HR_06 SMALLINT,
	HR_07 SMALLINT,
	HR_08 SMALLINT,
	HR_09 SMALLINT,
	HR_10 SMALLINT,
	HR_11 SMALLINT,
	HR_12 SMALLINT,
	HR_13 SMALLINT,
	HR_14 SMALLINT,
	HR_15 SMALLINT,
	HR_16 SMALLINT,
	HR_17 SMALLINT,
	HR_18 SMALLINT,
	HR_19 SMALLINT,
	HR_20 SMALLINT,
	HR_21 SMALLINT,
	HR_22 SMALLINT,
	HR_23 SMALLINT
);



--  Fato Eletrodomestico
CREATE TABLE F_ETDC(
	ID_F_ETDC SERIAL PRIMARY KEY,            	-- Id Fato Eletrodomestico
	ID_CTZC INT,                             	-- FK
	ID_DMCL INT,                             	-- FK
	ID_CLSS_SOCL INT ,                       	-- FK
	ID_MNCP INT,                             	-- FK
	ID_ETDC INT,                             	-- FK
	ID_FRQC_USO_ETDC INT, 						-- FK
	ID_DT_MES INT,                             -- FK
	ID_HRAR_USO INT,							-- FK
	QT_ETDC INT,                             	-- Quantidade eletrodomestico              
	TIPO_ETDC VARCHAR(60),				     	-- Tipo Eletrodomestico
	CPCD_AZTO VARCHAR(50),				     	-- Capacidade Armazenamento
	-- FRQC_USO VARCHAR(50),					 	-- Frequencia de Uso
	DSLG_TMDA_QUND_N_USO VARCHAR(25),        	-- Desliga da tomada quando não está em uso
	NU_ANO_POSSE_ETDC INT,                      -- Numero anos posse do aparelho (-1 para "Não sabe/não responde". -2 para não se aplica e vazio quando não informado)
	ADQD_NOVO_OU_USADO VARCHAR(25),          	-- Adquirido novo ou usado
	CPCD_TEMC_BTUH_ARCD VARCHAR(25),         	-- Capacidade termica Btu/h ar-condicionado
	CTLD_TMPR VARCHAR(35),                   	-- Controlador de temperatura
	TIPO_OPRC VARCHAR(35),                   	-- Tipo Operacao
	TMPR_COMUM_QUND_LIGAR_ARCD FLOAT,        	-- Temperatura comum quando ligar o ar-condicionado
	POSC_CTLD_TMPR_QUND_LIGAR_ARCD VARCHAR(35), -- Posicao controlador de temperatura ar-condicionado
	TP_MEDIO_DRCO_BANHO VARCHAR(25),        	-- Tempo médio duracao do banho
	NU_USO_DIAR_CE INT,                     	-- Numero uso diario chuveiro eletrico
	POTC_MAXM_CE VARCHAR(25),               	-- Potencia maxima chuveiro eletrico
	FONTE_ACMT_CE VARCHAR(35),              	-- Fonte aquecimento chuveiro eletrico
	TP_DIAR_CARGA_BTRA VARCHAR(20),         	-- Tempo diario carga bateria
	TMNH_POLD VARCHAR(25),                  	-- Tamanho Polegadas
	TP_USO_DIAR VARCHAR(25),                	-- Tempo de Uso diario
	NU_LVGM_MDL_DIA_USO INT,                	-- Numero Lavagens maquina de lavar dia de uso (-1 para "Não sabe/não responde". -2 para não se aplica (N/A) e vazio quando não informado)
	LIMPA_FTRO_ARCD_PRDT VARCHAR(25),       	-- Limpa filtro ar-condicionado periodicamente
	FOREIGN KEY(ID_ETDC) REFERENCES D_ETDC(ID_ETDC) ON DELETE CASCADE,
	FOREIGN KEY(ID_CTZC) REFERENCES D_CTZC(ID_CTZC) ON DELETE CASCADE,
	FOREIGN KEY(ID_DMCL) REFERENCES D_DMCL(ID_DMCL) ON DELETE CASCADE,
	FOREIGN KEY(ID_CLSS_SOCL) REFERENCES D_CLSS_SOCL(ID_CLSS_SOCL) ON DELETE CASCADE,
	FOREIGN KEY(ID_MNCP) REFERENCES D_MNCP(ID_MNCP) ON DELETE CASCADE,
	FOREIGN KEY(ID_FRQC_USO_ETDC) REFERENCES D_FRQC_USO_ETDC(ID_FRQC_USO_ETDC) ON DELETE CASCADE,
	FOREIGN KEY(ID_DT_MES) REFERENCES D_DT_MES(ID_DT_MES) ON DELETE CASCADE,
	FOREIGN KEY(ID_HRAR_USO) REFERENCES D_HRAR_USO(ID_HRAR_USO) ON DELETE CASCADE
);
