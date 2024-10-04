CREATE OR REPLACE VIEW csmo_ee_msal_rede_geral 
AS 
	SELECT 
		MNCP.*,
		CS.*,
		DM.*,
		CT.*,
		DT.*, 
		FC.NU_CSMO_EE_MSAL_KWH
	FROM F_CSMO_EE_MSAL FC 
		JOIN D_MNCP MNCP 
			ON FC.ID_MNCP = MNCP.ID_MNCP
		JOIN D_CLSS_SOCL CS 
			ON FC.ID_CLSS_SOCL = CS.ID_CLSS_SOCL
		JOIN D_DMCL DM 
			ON FC.ID_DMCL = DM.ID_DMCL
	    JOIN D_DT_MES DT 
			ON FC.ID_DT_MES = DT.ID_DT_MES
	    JOIN D_CTZC CT 
			ON FC.ID_CTZC = CT.ID_CTZC
	 WHERE dm.orig_ee_dmcl = 'Rede geral de distribuição (Concessionária de Energia Elétrica)';
*/


CREATE OR REPLACE VIEW dmcl_orig_ee_rede_geral
 AS
 SELECT *
   FROM d_dmcl
  WHERE orig_ee_dmcl = 'Rede geral de distribuição (Concessionária de Energia Elétrica)';
*/

/*	
SELECT FET.*
FROM F_ETDC FET 
	JOIN D_ETDC ET 
		ON FET.ID_ETDC = ET.ID_ETDC
	JOIN D_CTZC CT 
		ON FET.ID_CTZC = CT.ID_CTZC
	JOIN D_DMCL DM 
		ON FET.ID_DMCL = DM.ID_DMCL
	JOIN D_CLSS_SOCL CS 
		ON FET.ID_CLSS_SOCL = CS.ID_CLSS_SOCL
	JOIN D_MNCP MN 
		ON FET.ID_MNCP = MN.ID_MNCP
	JOIN D_FRQC_USO_ETDC FU 
		ON FET.ID_FRQC_USO_ETDC = FU.ID_FRQC_USO_ETDC
	JOIN D_DT_MES DT 
		ON FET.ID_DT_MES = DT.ID_DT_MES
	JOIN D_HRAR_USO HU 
		ON FET.ID_HRAR_USO = HU.ID_HRAR_USO
*/


-- Quantidade de entrevistas por região
SELECT CM.nm_regi AS "Regiao",
	count(*)/12 AS "Numero de entrevistas"
FROM csmo_ee_msal_rede_geral CM
GROUP BY CM.nm_regi
ORDER BY CM.nm_regi


-----------------------------------------------------------------------------
-- Media da quantidade de ar condicionado por regiao

WITH QT_ETDC_DMCL AS (
	SELECT MN.nm_regi,
		CS.CLSS_SOCL,
		FET.qt_etdc
	FROM F_ETDC FET
	JOIN D_ETDC ET 
		ON FET.ID_ETDC = ET.ID_ETDC
	JOIN D_MNCP MN 
		ON FET.ID_MNCP = MN.ID_MNCP
	JOIN dmcl_orig_ee_rede_geral DM 
		ON FET.ID_DMCL = DM.ID_DMCL
	JOIN D_CLSS_SOCL CS 
		ON FET.ID_CLSS_SOCL = CS.ID_CLSS_SOCL
	WHERE ET.nm_etdc = 'Ar-condicionado'
  AND FET.id_dt_mes = 1
)

SELECT
    nm_regi,
    AVG(qt_etdc)
FROM QT_ETDC_DMCL
GROUP BY nm_regi

UNION ALL

SELECT
    'Brasil',
    AVG(qt_etdc)
FROM QT_ETDC_DMCL

-- Media da quantidade de ar condicionado por Classe Social
SELECT CLSS_SOCL,
	AVG(qt_etdc) as media
FROM QT_ETDC_DMCL
group by CLSS_SOCL
order by CLSS_SOCL
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Quantidade de Eletrodomésticos em Domicílios por Classe Social
SELECT
    F.id_dmcl,
    CS.CLSS_SOCL,
    F.id_ctzc,
    F.id_mncp,
    COUNT(DISTINCT id_etdc) AS qt_etdc
FROM
    F_ETDC F
    JOIN (
        SELECT
            DISTINCT -- Tratar 12 domicílios repetidos
            FET.id_dmcl,
            FET.id_clss_socl,
            FET.id_ctzc,
            FET.id_mncp
        FROM
            F_ETDC FET
            JOIN dmcl_orig_ee_rede_geral DM ON FET.ID_DMCL = DM.ID_DMCL
        WHERE
            FET.id_dt_mes IN (1, 13, 14)
    ) DTDM ON (
        F.id_dmcl = DTDM.id_dmcl
        AND F.id_clss_socl = DTDM.id_clss_socl
        AND F.id_ctzc = DTDM.id_ctzc
        AND F.id_mncp = DTDM.id_mncp
    )
    JOIN D_CLSS_SOCL CS ON DTDM.id_clss_socl = CS.id_clss_socl
WHERE
    F.qt_etdc > 0
GROUP BY
    F.id_dmcl,
    CS.CLSS_SOCL,
    F.id_ctzc,
    F.id_mncp
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Quantidade de Eletrodomésticos em Funcionamento por Hora
SELECT
    SUM(HR_00) AS HR_00,
    SUM(HR_01) AS HR_01,
    SUM(HR_02) AS HR_02,
    SUM(HR_03) AS HR_03,
    SUM(HR_04) AS HR_04,
    SUM(HR_05) AS HR_05,
    SUM(HR_06) AS HR_06,
    SUM(HR_07) AS HR_07,
    SUM(HR_08) AS HR_08,
    SUM(HR_09) AS HR_09,
    SUM(HR_10) AS HR_10,
    SUM(HR_11) AS HR_11,
    SUM(HR_12) AS HR_12,
    SUM(HR_13) AS HR_13,
    SUM(HR_14) AS HR_14,
    SUM(HR_15) AS HR_15,
    SUM(HR_16) AS HR_16,
    SUM(HR_17) AS HR_17,
    SUM(HR_18) AS HR_18,
    SUM(HR_19) AS HR_19,
    SUM(HR_20) AS HR_20,
    SUM(HR_21) AS HR_21,
    SUM(HR_22) AS HR_22,
    SUM(HR_23) AS HR_23
FROM
    f_etdc FET
JOIN (
    SELECT
        *
    FROM
        D_HRAR_USO
    WHERE na IS NULL
        AND uso_evtl IS NULL
        AND id_hrar_uso <> 5 -- linha nula (sem resposta)
) HU ON FET.ID_HRAR_USO = HU.ID_HRAR_USO
JOIN dmcl_orig_ee_rede_geral DM 
	ON FET.ID_DMCL = DM.ID_DMCL
WHERE FET.id_dt_mes IN (1, 13, 14)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Distribuição de Respostas para Práticas de Economia de Energia
SELECT 
    'PRFR_EQPT_CSMR_MENOS_EE' AS CATEGORY,
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'Sempre' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Sempre",
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'Normalmente' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Normalmente",
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'Raramente' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Raramente",
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'Nunca' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Nunca",
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'N/A' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "N/A"
FROM 
    csmo_ee_msal_rede_geral
WHERE 
    ID_DT_MES = 1
    AND PRFR_EQPT_CSMR_MENOS_EE IS NOT NULL;
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Consumo médio anual por classe social
SELECT CM.clss_socl,
    AVG(CM.nu_csmo_ee_msal_kwh) as media_csmo_msal_kwh
FROM csmo_ee_msal_rede_geral CM
WHERE CM.nu_csmo_ee_msal_kwh IS NOT NULL
GROUP BY CM.clss_socl
ORDER BY CM.clss_socl
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Quantidade de Equipamentos de Climatização em Funcionamento por Hora
SELECT
    SUM(HR_00) AS HR_00,
    SUM(HR_01) AS HR_01,
    SUM(HR_02) AS HR_02,
    SUM(HR_03) AS HR_03,
    SUM(HR_04) AS HR_04,
    SUM(HR_05) AS HR_05,
    SUM(HR_06) AS HR_06,
    SUM(HR_07) AS HR_07,
    SUM(HR_08) AS HR_08,
    SUM(HR_09) AS HR_09,
    SUM(HR_10) AS HR_10,
    SUM(HR_11) AS HR_11,
    SUM(HR_12) AS HR_12,
    SUM(HR_13) AS HR_13,
    SUM(HR_14) AS HR_14,
    SUM(HR_15) AS HR_15,
    SUM(HR_16) AS HR_16,
    SUM(HR_17) AS HR_17,
    SUM(HR_18) AS HR_18,
    SUM(HR_19) AS HR_19,
    SUM(HR_20) AS HR_20,
    SUM(HR_21) AS HR_21,
    SUM(HR_22) AS HR_22,
    SUM(HR_23) AS HR_23
FROM
    f_etdc FET
JOIN (
    SELECT
        *
    FROM
        D_HRAR_USO
    WHERE na IS NULL
        AND uso_evtl IS NULL
        AND id_hrar_uso <> 5 -- linha nula (sem resposta)
) HU ON FET.ID_HRAR_USO = HU.ID_HRAR_USO
JOIN dmcl_orig_ee_rede_geral DM 
	ON FET.ID_DMCL = DM.ID_DMCL
JOIN D_ETDC ET 
	ON FET.ID_ETDC = ET.ID_ETDC
WHERE FET.id_dt_mes IN (1, 13, 14)
and ET.nm_etdc IN (
    'Ar-condicionado',
		'Aquecedor de ambiente',
		'Ventilador de teto',
		'Ventilador ou Circulador de ar')
--------------------------------------------------------------------------------
--CREATE VIEW QT_ELETRODOMESTICOS_POR_CLASSE_SOCIAL AS
WITH QT_ENTREVISTAS_CLSS_SOCL 
AS(
	SELECT CM.clss_socl AS classe_social,
		count(*)/12 AS numero_de_entrevistas
	FROM csmo_ee_msal_rede_geral CM
	GROUP BY CM.clss_socl
	ORDER BY CM.clss_socl
),
QT_ETDC_CLSS_SOCL AS (
	SELECT
		CS.CLSS_SOCL,
		ED.nm_etdc,
		COUNT(*) AS qt_dmcl_com_etdc -- número de domicílios que possuem determinado equipamento
	FROM
		F_ETDC F
		JOIN (
			SELECT
				DISTINCT -- Tratar 12 domicílios repetidos
				FET.id_dmcl,
				FET.id_clss_socl,
				FET.id_ctzc,
				FET.id_mncp
			FROM
				F_ETDC FET
				JOIN dmcl_orig_ee_rede_geral DM ON FET.ID_DMCL = DM.ID_DMCL
			WHERE
				FET.id_dt_mes IN (1, 13, 14)
		) DTDM ON (
			F.id_dmcl = DTDM.id_dmcl
			AND F.id_clss_socl = DTDM.id_clss_socl
			AND F.id_ctzc = DTDM.id_ctzc
			AND F.id_mncp = DTDM.id_mncp
		)
		JOIN D_CLSS_SOCL CS ON DTDM.id_clss_socl = CS.id_clss_socl
		JOIN D_ETDC ED ON ED.id_etdc = F.id_etdc
	WHERE 1=1 AND
		F.qt_etdc > 0
		--AND CS.clss_socl IN ('C2', 'D-E')
		AND F.id_dt_mes IN (1, 13, 14) -- remove as linhas onde há informações mensais sobre ar-condicionado
	GROUP BY
		CS.CLSS_SOCL,
		ED.nm_etdc	
)

SELECT * 
FROM(
	SELECT 
		QTET.CLSS_SOCL,
		QTET.nm_etdc,
		QTET.qt_dmcl_com_etdc,
		ROUND((QTET.qt_dmcl_com_etdc*100 / QTEN.numero_de_entrevistas), 2) AS PERCENTUAL_DMCL_COM_ETDC,
		ROW_NUMBER() OVER (PARTITION BY QTET.CLSS_SOCL ORDER BY ROUND((QTET.qt_dmcl_com_etdc*100 / QTEN.numero_de_entrevistas), 2) DESC) RN
	FROM QT_ETDC_CLSS_SOCL QTET
		LEFT JOIN QT_ENTREVISTAS_CLSS_SOCL QTEN
			ON QTET.CLSS_SOCL = QTEN.classe_social
)
WHERE RN <= 10

--------------------------------------------------------------------------------

SELECT
    SUM(HR_00) AS HR_00,
    SUM(HR_01) AS HR_01,
    SUM(HR_02) AS HR_02,
    SUM(HR_03) AS HR_03,
    SUM(HR_04) AS HR_04,
    SUM(HR_05) AS HR_05,
    SUM(HR_06) AS HR_06,
    SUM(HR_07) AS HR_07,
    SUM(HR_08) AS HR_08,
    SUM(HR_09) AS HR_09,
    SUM(HR_10) AS HR_10,
    SUM(HR_11) AS HR_11,
    SUM(HR_12) AS HR_12,
    SUM(HR_13) AS HR_13,
    SUM(HR_14) AS HR_14,
    SUM(HR_15) AS HR_15,
    SUM(HR_16) AS HR_16,
    SUM(HR_17) AS HR_17,
    SUM(HR_18) AS HR_18,
    SUM(HR_19) AS HR_19,
    SUM(HR_20) AS HR_20,
    SUM(HR_21) AS HR_21,
    SUM(HR_22) AS HR_22,
    SUM(HR_23) AS HR_23
FROM
    f_etdc FET
JOIN (
    SELECT
        *
    FROM
        D_HRAR_USO
    WHERE na IS NULL
        AND uso_evtl IS NULL
        AND id_hrar_uso <> 5 -- linha nula (sem resposta)
) HU ON FET.ID_HRAR_USO = HU.ID_HRAR_USO
JOIN dmcl_orig_ee_rede_geral DM 
	ON FET.ID_DMCL = DM.ID_DMCL
WHERE 1=1
	AND FET.id_dt_mes IN (1, 13, 14)
	AND FET.id_etdc IN (58, 62, 59, 48, 6, 57, 4, 54, 55, 56)



-- Quantidade de entrevistas por região e classe social
SELECT CM.nm_regi AS "Regiao",
	DC.clss_socl ,
	count(*)/12 AS "Numero de entrevistas"
FROM csmo_ee_msal_rede_geral CM
	JOIN d_clss_socl DC 
		ON CM.id_clss_socl = DC.id_clss_socl 
GROUP BY CM.nm_regi, DC.clss_socl
ORDER BY CM.nm_regi, DC.clss_socl


-- Agrupamento por região
SELECT DISTINCT
    'PRFR_EQPT_CSMR_MENOS_EE' AS CATEGORY,
	CS.nm_regi,
	ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'Sempre' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Sempre",
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'Normalmente' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Normalmente",
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'Raramente' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Raramente",
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'Nunca' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Nunca",
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'N/A' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "N/A"
FROM 
    csmo_ee_msal_rede_geral CS
WHERE 1=1
    AND CS.ID_DT_MES = 1
    AND CS.PRFR_EQPT_CSMR_MENOS_EE IS NOT NULL
GROUP BY CS.nm_regi

-- SELECT column_name, data_type, character_maximum_length FROM information_schema. columns WHERE table_name = 'd_mncp';


-- Agrupamento por classe social
SELECT DISTINCT
    'PRFR_EQPT_CSMR_MENOS_EE' AS CATEGORY,
	CS.clss_socl,
	ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'Sempre' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Sempre",
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'Normalmente' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Normalmente",
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'Raramente' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Raramente",
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'Nunca' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "Nunca",
    ROUND(SUM(CASE WHEN PRFR_EQPT_CSMR_MENOS_EE = 'N/A' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS "N/A"
FROM 
    csmo_ee_msal_rede_geral CS
WHERE 1=1
    AND CS.ID_DT_MES = 1
    AND CS.PRFR_EQPT_CSMR_MENOS_EE IS NOT NULL
GROUP BY CS.clss_socl







