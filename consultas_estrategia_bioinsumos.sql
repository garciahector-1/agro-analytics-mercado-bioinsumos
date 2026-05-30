-- ==============================================================================
-- PROYECTO: AGRO-ANALYTICS - ESTRATEGIA COMERCIAL DE BIOINSUMOS EN EL MERCOSUR
-- AUTOR: Técnico Agropecuario & Analista de Datos
-- OBJETIVO: Inteligencia de datos y modelos predictivos para la campaña 2026/27
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- SCRIPT 1: ESTRUCTURA Y CARGA DE DATOS HISTÓRICOS MACRO-CLIMÁTICOS DE BRASIL (CONAB)
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS macro_clima_brasil;

CREATE TABLE macro_clima_brasil (
    id_estado INT4,
    estado VARCHAR(50),
    region VARCHAR(30),
    campana VARCHAR(20),
    lluvia_total_ciclo_mm NUMERIC,
    temp_max_critica NUMERIC,
    humedad_prom_critica NUMERIC,
    supsembrada NUMERIC,
    supcosechada NUMERIC,
    rendimiento INT4
);

INSERT INTO macro_clima_brasil 
(id_estado, estado, region, campana, lluvia_total_ciclo_mm, temp_max_critica, humedad_prom_critica, supsembrada, supcosechada, rendimiento) 
VALUES
(51, 'MATO GROSSO', 'CERRADO', '2011/12', 850.0, 33.1, 62.0, 7000000, 6980000, 3120),
(51, 'MATO GROSSO', 'CERRADO', '2014/15', 1320.0, 31.4, 76.5, 8900000, 8895000, 3280),
(51, 'MATO GROSSO', 'CERRADO', '2017/18', 1100.0, 32.0, 71.0, 9500000, 9498000, 3520),
(41, 'PARANA', 'SUDESTE', '2011/12', 610.0, 31.2, 58.5, 4700000, 4650000, 2180),
(41, 'PARANA', 'SUDESTE', '2014/15', 1150.0, 29.5, 78.0, 5200000, 5080000, 3310),
(41, 'PARANA', 'SUDESTE', '2017/18', 920.0, 30.1, 72.1, 5400000, 5395000, 3740);


-- ------------------------------------------------------------------------------
-- SCRIPT 2: QUERY DE CRUCE ESPEJO INTERNACIONAL (EFICIENCIA DE USO DEL AGUA)
-- ------------------------------------------------------------------------------
WITH clima_ciclo_arg AS (
    SELECT iddepartamento, campana, SUM(precipitacion_mm) as lluvia_mm
    FROM clima_campana
    GROUP BY iddepartamento, campana
),
clima_critico_arg AS (
    SELECT iddepartamento, campana,
        ROUND(AVG(temp_max_media)::numeric, 1) as temp_max,
        ROUND(AVG(humedad_relativa_prom)::numeric, 1) as humedad
    FROM clima_campana
    WHERE mes IN (1, 2)
    GROUP BY iddepartamento, campana
),
argentina_consolidado AS (
    SELECT 
        CASE 
            WHEN e.iddepartamento = 28 THEN 'CHACO (CHACABUCO)'
            WHEN e.iddepartamento = 623 THEN 'ARG_ZONA_NUCLEO (PERGAMINO)'
        END as region_analisis,
        e.campana, cc.lluvia_mm, cl.temp_max, cl.humedad, e.rendimiento as rinde_kg_ha
    FROM estimaciones_macro e
    INNER JOIN clima_ciclo_arg cc ON e.iddepartamento = cc.iddepartamento AND e.campana = cc.campana
    INNER JOIN clima_critico_arg cl ON e.iddepartamento = cl.iddepartamento AND e.campana = cl.campana
    WHERE e.cultivo ILIKE '%soja%' AND e.iddepartamento IN (28, 623)
),
brasil_consolidado AS (
    SELECT 
        CASE 
            WHEN region = 'CERRADO' THEN 'BRASIL_CERRADO (MATO GROSSO)'
            WHEN region = 'SUDESTE' THEN 'BRASIL_SUR (PARANA)'
        END as region_analisis,
        campana, lluvia_total_ciclo_mm as lluvia_mm, temp_max_critica as temp_max, humedad_prom_critica as humedad, rendimiento as rinde_kg_ha
    FROM macro_clima_brasil
)
SELECT region_analisis, campana, lluvia_mm, temp_max as soplete_c, humedad as humedad_pct, rinde_kg_ha,
    ROUND((rinde_kg_ha / NULLIF(lluvia_mm, 0)), 2) as eua_kg_mm
FROM argentina_consolidado
WHERE campana IN ('2011/12', '2014/15', '2017/18')
UNION ALL
SELECT region_analisis, campana, lluvia_mm, temp_max as soplete_c, humedad as humedad_pct, rinde_kg_ha,
    ROUND((rinde_kg_ha / NULLIF(lluvia_mm, 0)), 2) as eua_kg_mm
FROM brasil_consolidado
ORDER BY campana, region_analisis;


-- ------------------------------------------------------------------------------
-- SCRIPT 3: MODELO PREDICTIVO CON RECOMENDACIÓN AUTOMÁTICA Y COSTOS VARIABLES
-- ------------------------------------------------------------------------------
WITH simulacion_escenarios AS (
    SELECT 'CHACO (CHACABUCO)' as region, 'NINO EXTREMO' as pronostico, 318 as rinde_extra_estimado_kg, 14.0 as costo_aplicacion_usd
    UNION ALL
    SELECT 'CHACO (CHACABUCO)', 'NINA / SECO', 210, 7.0
    UNION ALL
    SELECT 'ARG_ZONA_NUCLEO (PERGAMINO)', 'NINO EXTREMO', 350, 14.0
    UNION ALL
    SELECT 'ARG_ZONA_NUCLEO (PERGAMINO)', 'NINA / SECO', 250, 7.0
    UNION ALL
    SELECT 'BRASIL_CERRADO (MATO GROSSO)', 'NINO EXTREMO', 280, 10.0
    UNION ALL
    SELECT 'BRASIL_CERRADO (MATO GROSSO)', 'NINA / SECO', 160, 7.0
),
calculos_proyeccion AS (
    SELECT region, pronostico, rinde_extra_estimado_kg, 0.30 as precio_soja_usd_kg, 18.0 as costo_bioinsumo_usd_ha,
        costo_aplicacion_usd, (18.0 + costo_aplicacion_usd) as costo_total_usd
    FROM simulacion_escenarios
)
SELECT 
    region, pronostico, rinde_extra_estimado_kg as rinde_defendido_kg,
    ROUND((rinde_extra_estimado_kg * precio_soja_usd_kg - costo_total_usd)::numeric, 1) as margen_neto_proyectado_usd,
    ROUND(((rinde_extra_estimado_kg * precio_soja_usd_kg) / costo_total_usd)::numeric, 2) as roi_proyectado,
    CASE 
        WHEN costo_aplicacion_usd = 14.0 THEN 'ALTA HUMEDAD: Bloquear aplicaciones terrestres. Contratar preventivamente flota de Aviones.'
        ELSE 'MANEJO DE SECANO: Aplicación terrestre convencional (Mosquito).'
    END as logistica_operativa,
    CASE 
        WHEN region LIKE '%BRASIL%' AND pronostico = 'NINO EXTREMO' THEN 'FOCO BRASIL: Campaña de Marketing basada en EVITAR LIXIVIACIÓN de nutrientes en suelos Oxisoles.'
        WHEN region LIKE '%BRASIL%' AND pronostico = 'NINA / SECO' THEN 'FOCO BRASIL: Posicionar solubilizadores biológicos para potenciar raíces en suelos arenosos.'
        WHEN pronostico = 'NINO EXTREMO' THEN 'FOCO ARGENTINA: Vender REANIMACIÓN foliar post-anegamiento y protección contra Hongos de Fin de Ciclo.'
        ELSE 'FOCO ARGENTINA: Vender osmorreguladores para mitigar el aborto de flores por soplete térmico.'
    END as estrategia_comercial_marketing
FROM calculos_proyeccion
ORDER BY region, roi_proyectado DESC;
