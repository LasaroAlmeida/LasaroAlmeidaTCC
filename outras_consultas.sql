
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