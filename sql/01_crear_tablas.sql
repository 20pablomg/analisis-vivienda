CREATE TABLE tasa (
    cod_territorio TEXT,
    territorio TEXT NOT NULL,
    anio INTEGER NOT NULL,
    trimestre INTEGER NOT NULL,
    valor_m2 REAL,

    PRIMARY KEY (territorio, anio, trimestre),

    CHECK (trimestre BETWEEN 1 AND 4),
    CHECK (valor_m2 > 0)
);

SELECT name
FROM sqlite_master
WHERE type = 'table';

SELECT COUNT(*) AS registros
FROM tasa;

SELECT
    COUNT(*) AS registros,
    COUNT(DISTINCT territorio) AS territorios,
    SUM(CASE WHEN valor_m2 IS NULL THEN 1 ELSE 0 END) AS valores_nulos
FROM tasa;


CREATE TABLE ipv (
    cod_territorio TEXT,
    territorio TEXT NOT NULL,
    anio INTEGER NOT NULL,
    trimestre INTEGER NOT NULL,
    tipo_vivienda TEXT NOT NULL,
    indice_ipv REAL,

    PRIMARY KEY (
        territorio,
        anio,
        trimestre,
        tipo_vivienda
    ),

    CHECK (trimestre BETWEEN 1 AND 4),
    CHECK (indice_ipv > 0)
);

SELECT COUNT(*) AS registros
FROM ipv;

SELECT
    COUNT(*) AS registros,
    COUNT(DISTINCT territorio) AS territorios,
    SUM(CASE WHEN indice_ipv IS NULL THEN 1 ELSE 0 END) AS valores_nulos
FROM ipv;


CREATE TABLE ipc (
    cod_territorio TEXT,
    territorio TEXT NOT NULL,
    anio INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    grupo_consumo TEXT NOT NULL,
    indice_ipc REAL,

    PRIMARY KEY (
        territorio,
        anio,
        mes,
        grupo_consumo
    ),

    CHECK (mes BETWEEN 1 AND 12),
    CHECK (indice_ipc > 0)
);

SELECT COUNT(*) AS registros
FROM ipc;

SELECT
    COUNT(*) AS registros,
    COUNT(DISTINCT territorio) AS territorios,
    SUM(CASE WHEN indice_ipc IS NULL THEN 1 ELSE 0 END) AS valores_nulos
FROM ipc;


CREATE TABLE salarios (
    cod_territorio TEXT,
    territorio TEXT NOT NULL,
    anio INTEGER NOT NULL,
    salario_medio REAL NOT NULL,

    PRIMARY KEY (
        territorio,
        anio
    ),

    CHECK (salario_medio > 0)
);

SELECT COUNT(*) AS registros
FROM salarios;

SELECT
    COUNT(*) AS registros,
    COUNT(DISTINCT territorio) AS territorios,
    SUM(CASE WHEN salario_medio IS NULL THEN 1 ELSE 0 END) AS valores_nulos
FROM salarios;