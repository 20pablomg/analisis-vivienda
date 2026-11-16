-- ============================================================
-- ANÁLISIS DEL MERCADO DE VIVIENDA EN ASTURIAS
-- Comparación con España y la Comunidad de Madrid
-- ============================================================

-- VISTAS REUTILIZABLES
-- ------------------------------------------------------------

-- IPV general: valores de los trimestres extremos (2007T1 y 2026T2).
DROP VIEW IF EXISTS comparacion_ipv;
CREATE VIEW comparacion_ipv AS
SELECT
    territorio,
    MAX(CASE WHEN anio = 2007 AND trimestre = 1 THEN indice_ipv END) AS ipv_inicial,
    MAX(CASE WHEN anio = 2026 AND trimestre = 2 THEN indice_ipv END) AS ipv_final
FROM ipv
WHERE territorio IN (
    'Asturias, Principado de',
    'Nacional',
    'Madrid, Comunidad de'
)
AND tipo_vivienda = 'General'
GROUP BY territorio;

-- IPC: medias trimestrales del índice general y del grupo de alimentos.
-- Permite comparar el IPC mensual con el IPV trimestral.
DROP VIEW IF EXISTS ipc_trimestral;
CREATE VIEW ipc_trimestral AS
SELECT
    territorio,
    anio,
    (mes - 1) / 3 + 1 AS trimestre,
    grupo_consumo,
    AVG(indice_ipc) AS ipc_medio
FROM ipc
WHERE grupo_consumo IN (
    'Índice general',
    '01 Alimentos y bebidas no alcohólicas'
)
GROUP BY territorio, anio, (mes - 1) / 3 + 1, grupo_consumo;

-- IPC general: extremos para todas las comunidades autónomas.
DROP VIEW IF EXISTS comparacion_ipc;
CREATE VIEW comparacion_ipc AS
SELECT
    territorio,
    MAX(CASE WHEN anio = 2007 AND trimestre = 1 THEN ipc_medio END) AS ipc_inicial,
    MAX(CASE WHEN anio = 2026 AND trimestre = 2 THEN ipc_medio END) AS ipc_final
FROM ipc_trimestral
WHERE grupo_consumo = 'Índice general'
GROUP BY territorio;

-- Valor tasado medio anual de vivienda libre (€/m²).
-- Periodo compatible con la serie anual de salarios: 2008-2024.
DROP VIEW IF EXISTS tasa_anual;
CREATE VIEW tasa_anual AS
SELECT
    territorio,
    anio,
    AVG(valor_m2) AS valor_m2_medio
FROM tasa
WHERE territorio IN (
    'Asturias, Principado de',
    'Nacional',
    'Madrid, Comunidad de'
)
AND anio BETWEEN 2008 AND 2024
GROUP BY territorio, anio;

-- ============================================================
-- PREGUNTA 1
-- ¿Cuánto se ha encarecido la vivienda desde 2007?
-- ¿Ha subido más en Asturias que en España?
-- ============================================================
SELECT
    territorio,
    ipv_inicial,
    ipv_final,
    ROUND(100.0 * (ipv_final / NULLIF(ipv_inicial, 0) - 1), 2) AS variacion_ipv_pct
FROM comparacion_ipv
ORDER BY territorio;

-- ============================================================
-- PREGUNTA 2
-- ¿Ha aumentado la vivienda más que la inflación general?
-- Periodo: 2007T1 - 2026T2.
-- El crecimiento real descuenta la inflación.
-- ============================================================
SELECT
    i.territorio,
    ROUND(100.0 * (i.ipv_final / NULLIF(i.ipv_inicial, 0) - 1), 2) AS variacion_ipv_pct,
    ROUND(100.0 * (c.ipc_final / NULLIF(c.ipc_inicial, 0) - 1), 2) AS variacion_ipc_pct,
    ROUND(100.0 * (
        (i.ipv_final / NULLIF(i.ipv_inicial, 0)) /
        NULLIF(c.ipc_final / NULLIF(c.ipc_inicial, 0), 0) - 1
    ), 2) AS variacion_ipv_real_pct
FROM comparacion_ipv AS i
INNER JOIN comparacion_ipc AS c
    ON i.territorio = c.territorio
ORDER BY i.territorio;

-- Ampliación 2.1: influencia del año inicial (2007, 2014 y 2020).
-- Se comparan siempre T1 del año inicial y 2026T2.
-- Incluye el IPV nominal, la inflación general y el IPV real.
WITH periodos AS (
    SELECT 2007 AS anio_inicial
    UNION ALL SELECT 2014
    UNION ALL SELECT 2020
)
SELECT
    p.anio_inicial,
    ini.territorio,
    ROUND(100.0 * (fin.indice_ipv / NULLIF(ini.indice_ipv, 0) - 1), 2)
        AS variacion_ipv_pct,
    ROUND(100.0 * (ipc_fin.ipc_medio / NULLIF(ipc_ini.ipc_medio, 0) - 1), 2)
        AS variacion_ipc_pct,
    ROUND(100.0 * (
        (fin.indice_ipv / NULLIF(ini.indice_ipv, 0)) /
        NULLIF(ipc_fin.ipc_medio / NULLIF(ipc_ini.ipc_medio, 0), 0) - 1
    ), 2) AS variacion_ipv_real_pct
FROM periodos AS p
INNER JOIN ipv AS ini
    ON ini.anio = p.anio_inicial
    AND ini.trimestre = 1
    AND ini.tipo_vivienda = 'General'
INNER JOIN ipv AS fin
    ON fin.territorio = ini.territorio
    AND fin.anio = 2026
    AND fin.trimestre = 2
    AND fin.tipo_vivienda = 'General'
INNER JOIN ipc_trimestral AS ipc_ini
    ON ipc_ini.territorio = ini.territorio
    AND ipc_ini.anio = p.anio_inicial
    AND ipc_ini.trimestre = 1
    AND ipc_ini.grupo_consumo = 'Índice general'
INNER JOIN ipc_trimestral AS ipc_fin
    ON ipc_fin.territorio = ini.territorio
    AND ipc_fin.anio = 2026
    AND ipc_fin.trimestre = 2
    AND ipc_fin.grupo_consumo = 'Índice general'
WHERE ini.territorio IN (
    'Asturias, Principado de',
    'Nacional',
    'Madrid, Comunidad de'
)
ORDER BY ini.territorio, p.anio_inicial;

-- Ampliación 2.2: IPC de alimentos como contraste complementario,
-- NO como sustituto de la inflación general.
-- Comparación de las tres series: 2007T1 - 2026T2.
WITH comparacion_alimentos AS (
    SELECT
        territorio,
        MAX(CASE WHEN anio = 2007 AND trimestre = 1 THEN ipc_medio END)
            AS alimentos_inicial,
        MAX(CASE WHEN anio = 2026 AND trimestre = 2 THEN ipc_medio END)
            AS alimentos_final
    FROM ipc_trimestral
    WHERE grupo_consumo = '01 Alimentos y bebidas no alcohólicas'
    GROUP BY territorio
)
SELECT
    i.territorio,
    ROUND(100.0 * (i.ipv_final / NULLIF(i.ipv_inicial, 0) - 1), 2)
        AS variacion_ipv_pct,
    ROUND(100.0 * (c.ipc_final / NULLIF(c.ipc_inicial, 0) - 1), 2)
        AS variacion_ipc_general_pct,
    ROUND(100.0 * (a.alimentos_final / NULLIF(a.alimentos_inicial, 0) - 1), 2)
        AS variacion_ipc_alimentos_pct
FROM comparacion_ipv AS i
INNER JOIN comparacion_ipc AS c ON c.territorio = i.territorio
INNER JOIN comparacion_alimentos AS a ON a.territorio = i.territorio
ORDER BY i.territorio;

-- ¿Ha tenido Asturias una inflación especialmente alta?
-- Clasificación de las 17 CCAA (sin Nacional, Ceuta ni Melilla).
WITH inflacion_ccaa AS (
    SELECT
        territorio,
        ROUND(100.0 * (ipc_final / NULLIF(ipc_inicial, 0) - 1), 2)
            AS inflacion_pct
    FROM comparacion_ipc
    WHERE territorio NOT IN ('Nacional', 'Ceuta', 'Melilla')
)
SELECT
    territorio,
    inflacion_pct,
    RANK() OVER (ORDER BY inflacion_pct DESC) AS posicion_ccaa
FROM inflacion_ccaa
ORDER BY posicion_ccaa, territorio;

-- ============================================================
-- PREGUNTA 3
-- ¿Han crecido los salarios al ritmo de los precios de vivienda?
-- Periodo: 2008-2024 (medias anuales del IPV).
-- ============================================================
WITH ipv_anual AS (
    SELECT
        territorio,
        anio,
        AVG(indice_ipv) AS ipv_medio
    FROM ipv
    WHERE territorio IN (
        'Asturias, Principado de',
        'Nacional',
        'Madrid, Comunidad de'
    )
    AND tipo_vivienda = 'General'
    AND anio BETWEEN 2008 AND 2024
    GROUP BY territorio, anio
),
comparacion_ipv_anual AS (
    SELECT
        territorio,
        MAX(CASE WHEN anio = 2008 THEN ipv_medio END) AS ipv_inicial,
        MAX(CASE WHEN anio = 2024 THEN ipv_medio END) AS ipv_final
    FROM ipv_anual
    GROUP BY territorio
),
comparacion_salarios AS (
    SELECT
        territorio,
        MAX(CASE WHEN anio = 2008 THEN salario_medio END) AS salario_inicial,
        MAX(CASE WHEN anio = 2024 THEN salario_medio END) AS salario_final
    FROM salarios
    WHERE territorio IN (
        'Asturias, Principado de',
        'Nacional',
        'Madrid, Comunidad de'
    )
    GROUP BY territorio
)
SELECT
    i.territorio,
    ROUND(i.ipv_inicial, 2) AS ipv_inicial,
    ROUND(i.ipv_final, 2) AS ipv_final,
    ROUND(100.0 * (i.ipv_final / NULLIF(i.ipv_inicial, 0) - 1), 2)
        AS variacion_ipv_pct,
    s.salario_inicial,
    s.salario_final,
    ROUND(100.0 * (s.salario_final / NULLIF(s.salario_inicial, 0) - 1), 2)
        AS variacion_salario_pct,
    -- Diferencia de tasas acumuladas en puntos porcentuales.
    ROUND(100.0 * (
        i.ipv_final / NULLIF(i.ipv_inicial, 0)
        - s.salario_final / NULLIF(s.salario_inicial, 0)
    ), 2) AS diferencia_pp
FROM comparacion_ipv_anual AS i
INNER JOIN comparacion_salarios AS s ON i.territorio = s.territorio
ORDER BY i.territorio;

-- ============================================================
-- PREGUNTA 4
-- ¿Cómo ha evolucionado el valor tasado por metro cuadrado?
-- ¿Qué diferencias existen frente a España?
-- Periodo: 2008-2024.
-- ============================================================
WITH comparacion_tasa AS (
    SELECT
        territorio,
        MAX(CASE WHEN anio = 2008 THEN valor_m2_medio END) AS valor_m2_inicial,
        MAX(CASE WHEN anio = 2024 THEN valor_m2_medio END) AS valor_m2_final
    FROM tasa_anual
    GROUP BY territorio
),
comparacion_salarios AS (
    SELECT
        territorio,
        MAX(CASE WHEN anio = 2008 THEN salario_medio END) AS salario_inicial,
        MAX(CASE WHEN anio = 2024 THEN salario_medio END) AS salario_final
    FROM salarios
    WHERE territorio IN (
        'Asturias, Principado de',
        'Nacional',
        'Madrid, Comunidad de'
    )
    GROUP BY territorio
)
SELECT
    t.territorio,
    ROUND(t.valor_m2_inicial, 2) AS valor_m2_inicial,
    ROUND(t.valor_m2_final, 2) AS valor_m2_final,
    ROUND(100.0 * (t.valor_m2_final / NULLIF(t.valor_m2_inicial, 0) - 1), 2)
        AS variacion_valor_m2_pct,
    s.salario_inicial,
    s.salario_final,
    ROUND(100.0 * (s.salario_final / NULLIF(s.salario_inicial, 0) - 1), 2)
        AS variacion_salario_pct,
    -- Diferencia de tasas acumuladas en puntos porcentuales.
    ROUND(100.0 * (
        t.valor_m2_final / NULLIF(t.valor_m2_inicial, 0)
        - s.salario_final / NULLIF(s.salario_inicial, 0)
    ), 2) AS diferencia_pp
FROM comparacion_tasa AS t
INNER JOIN comparacion_salarios AS s ON t.territorio = s.territorio
ORDER BY t.territorio;

-- ¿Cuántos salarios brutos anuales representa el valor tasado
-- estimado de una vivienda de 80 m²? No equivale a años de ahorro.
SELECT
    t.territorio,
    t.anio,
    ROUND(t.valor_m2_medio * 80, 2) AS valor_vivienda_80m2,
    s.salario_medio,
    ROUND(t.valor_m2_medio * 80 / NULLIF(s.salario_medio, 0), 2)
        AS n_salarios_brutos_anuales
FROM tasa_anual AS t
INNER JOIN salarios AS s
    ON t.territorio = s.territorio
    AND t.anio = s.anio
WHERE t.anio IN (2008, 2012, 2016, 2020, 2024)
ORDER BY t.territorio, t.anio;
