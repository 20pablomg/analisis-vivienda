# Limpieza y transformación de datos

## 1. Objetivo

Preparar las cuatro fuentes principales del proyecto de análisis de vivienda para su posterior integración en SQL y visualización en Power BI.

Las transformaciones se realizan mediante Python y pandas en `notebooks/limpieza_core.ipynb`, conservando los archivos originales.

## 2. Fuentes procesadas

| Fuente | Archivo procesado | Periodicidad | Registros |
|---|---|---|---:|
| Índice de Precios de Vivienda (INE) | `ipv.csv` | Trimestral | 4.680 |
| Índice de Precios de Consumo (INE) | `ipc.csv` | Mensual | 83.160 |
| Ganancia media anual por trabajador (INE) | `salarios.csv` | Anual | 306 |
| Valor tasado de vivienda | `tasa.csv` | Trimestral | 2.520 |

## 3. Transformaciones realizadas

### IPV

- Selección de los índices de precios.
- Transformación de formato ancho a largo.
- Separación de año y trimestre.
- Normalización de los nombres y códigos territoriales.
- Conservación de 312 valores ausentes correspondientes a categorías de vivienda nueva y usada de Ceuta y Melilla.

### IPC

- Selección de los índices de precios de consumo.
- Transformación de formato ancho a largo.
- Separación de año y mes.
- Identificación del índice general y los 13 grupos de consumo.
- Normalización territorial.
- Validación de 83.160 registros sin valores ausentes ni duplicados.

### Salarios

- Extracción de la ganancia media anual por trabajador para ambos sexos y todos los sectores.
- Transformación a formato largo.
- Conversión de los valores salariales a formato numérico.
- Normalización territorial.
- Validación de 306 registros sin valores ausentes.
- Identificación de la ausencia de Ceuta y Melilla en esta fuente.

### Valor tasado

- Selección de vivienda libre y datos territoriales agregados.
- Exclusión de observaciones provinciales cuando existe agregado autonómico.
- Eliminación de 110 registros duplicados exactos de Navarra.
- Normalización territorial.
- Conservación de 72 valores ausentes originales de Ceuta y Melilla entre 1995 y 2003.
- Reclasificación como ausente de un valor de 0 €/m² correspondiente a Melilla en 2013T3.

El resultado contiene 2.520 registros y 73 valores ausentes.

## 4. Control de calidad

Se han aplicado comprobaciones de:

- Dimensiones y número de territorios.
- Tipos de datos y valores ausentes.
- Duplicados según las claves temporales y territoriales.
- Coherencia de los códigos territoriales.
- Validez de los periodos y valores numéricos.

## 5. Resultados y siguientes pasos

Los cuatro datasets se exportan en formato CSV a `data/processed/core/`.

Quedan preparados para la siguiente fase del proyecto: carga en SQL, definición de las tablas y construcción de consultas para el análisis de la evolución del mercado de vivienda y su relación con los salarios y la inflación.

**Limitación metodológica:** las fuentes presentan diferentes periodos y frecuencias temporales. Su integración requerirá seleccionar intervalos comparables y justificar las agregaciones temporales utilizadas.