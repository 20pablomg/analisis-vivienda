# Auditoría exploratoria — núcleo de vivienda en Asturias

Generado automáticamente desde archivos originales. Este informe es **descriptivo**: no limpia, elimina ni une datos.

## Inventario

- **IPV**: `data/raw/core/base25_raw.xlsx`
- **IPC**: `data/raw/core/ipcgrupos_raw.xlsx`
- **Salarios**: `data/raw/core/salarios_raw.xlsx`
- **Valor tasado**: `data/raw/core/tasa_raw.csv`

## IPV
Archivo: `base25_raw.xlsx`

- Dimensiones originales: **94 filas × 313 columnas**.
- Lectura con `header=None` para no perder las filas informativas del INE.

### Vista de encabezados (primeras 12 filas, 5 columnas)
| Fila Excel aprox. | Columna 1 | Columna 2 | Columna 3 | Columna 4 | Columna 5 |
| --- | --- | --- | --- | --- | --- |
| 1 | Índice de Precios de Vivienda. Base 2025 |  |  |  |  |
| 2 | Índice de Precios de Vivienda (IPV). Base 2025 |  |  |  |  |
| 3 |  |  |  |  |  |
| 4 | Índices por CCAA: general, vivienda nueva y de segunda mano |  |  |  |  |
| 5 | Unidades: Índice, Tasas |  |  |  |  |
| 6 |  |  |  |  |  |
| 7 |  | Índice |  |  |  |
| 8 |  | 2026T2 | 2026T1 | 2025T4 | 2025T3 |
| 9 | Nacional |  |  |  |  |
| 10 | General | 111.095 | 107.458 | 103.805 | 101.937 |
| 11 | Vivienda nueva | 107.228 | 106.129 | 102.559 | 100.371 |
| 12 | Vivienda segunda mano | 111.682 | 107.666 | 104.001 | 102.183 |

- Periodos detectados en cabeceras: **2007T1 — 2026T2** (78 diferentes).

### Identificación de territorios y variables
- Etiquetas con Asturias en la primera columna: **1**.
- Etiquetas con España/Total Nacional en la primera columna: **2**.
- Ejemplos de etiquetas: `Vivienda nueva`; `Vivienda segunda mano`; `01 Andalucía`; `General`; `Vivienda nueva`; `Vivienda segunda mano`; `02 Aragón`; `General`; `Vivienda nueva`; `Vivienda segunda mano`; `03 Asturias, Principado de`; `General`

### Comprobación de calidad (preliminar)
- Celdas vacías en toda la hoja: **10,297**.
- **No interpretar esas celdas como datos ausentes reales**: hay encabezados y separadores.
- Duplicados por territorio-periodo: no evaluables hasta identificar y normalizar las claves.


### Interpretación de la estructura
- **Filas Excel 1–6:** título, descripción, unidades y separadores; la mayor parte de las celdas restantes están vacías.
- **Fila Excel 7:** identifica cuatro bloques de medidas en columnas: **Índice** (columna B), **variación trimestral** (columna CB; posición 79 de pandas), **variación anual** (columna FB; posición 157) y **variación en lo que va de año** (columna IB; posición 235). Cada bloque contiene los mismos 78 trimestres.
- **Fila Excel 8:** contiene los periodos trimestrales, de 2026T2 a 2007T1 en orden descendente, repetidos por bloque de medida.
- **Desde la fila Excel 9:** bloques de **4 filas por territorio**: nombre del territorio en una fila sin valores numéricos, seguido de **General**, **Vivienda nueva** y **Vivienda segunda mano**. Asturias empieza en la fila 21; los valores están en las filas 22–24.
- **Columnas B hasta la última:** observaciones por periodo y medida. Las filas territoriales y las celdas de texto/separación no son datos faltantes.
- **Últimas filas:** notas y fuente, no observaciones.

**Unidad:** índice (base 2025) o porcentaje, según el bloque. **Granularidad futura:** territorio × tipo de vivienda × trimestre × medida.

**Preparación prevista:** extraer los cuatro bloques identificados en la fila 7, asociar a cada valor su trimestre y su territorio, separar los tres tipos de vivienda, convertir a formato largo y tipar índices/variaciones como números.


## IPC
Archivo: `ipcgrupos_raw.xlsx`

- Dimensiones originales: **314 filas × 1189 columnas**.
- Lectura con `header=None` para no perder las filas informativas del INE.

### Vista de encabezados (primeras 12 filas, 5 columnas)
| Fila Excel aprox. | Columna 1 | Columna 2 | Columna 3 | Columna 4 | Columna 5 |
| --- | --- | --- | --- | --- | --- |
| 1 | Indice de Precios de Consumo. Base 2025 |  |  |  |  |
| 2 | Resultados por comunidades autónomas |  |  |  |  |
| 3 |  |  |  |  |  |
| 4 | Índices por comunidades autónomas: general y de grupos ECOICOP ver.2 |  |  |  |  |
| 5 | Unidades:   Índice,   Tasas |  |  |  |  |
| 6 |  |  |  |  |  |
| 7 |  | Índice |  |  |  |
| 8 |  | 2026M09 | 2026M08 | 2026M07 | 2026M06 |
| 9 | Nacional |  |  |  |  |
| 10 | Índice general | 104.978 | 104.638 | 103.899 | 103.598 |
| 11 | 01 Alimentos y bebidas no alcohólicas | 101.934 | 101.71 | 101.843 | 102.527 |
| 12 | 02 Bebidas alcohólicas y tabaco | 103.289 | 103.106 | 103.166 | 103.399 |

- Periodos detectados en cabeceras: **2002M01 — 2026M09** (297 diferentes).

### Identificación de territorios y variables
- Etiquetas con Asturias en la primera columna: **1**.
- Etiquetas con España/Total Nacional en la primera columna: **2**.
- Ejemplos de etiquetas: `01 Alimentos y bebidas no alcohólicas`; `02 Bebidas alcohólicas y tabaco`; `03 Vestido y calzado`; `04 Vivienda, agua, electricidad, gas y otros combustibles`; `05 Muebles, artículos del hogar y artículos para el mantenimiento corriente del hogar`; `06 Sanidad`; `07 Transporte`; `08 Información y comunicaciones`; `09 Actividades recreativas, deporte y cultura`; `10 Enseñanza`; `11 Restaurantes y servicios de alojamiento`; `12 Seguros y servicios financieros`

### Comprobación de calidad (preliminar)
- Celdas vacías en toda la hoja: **39,205**.
- **No interpretar esas celdas como datos ausentes reales**: hay encabezados y separadores.
- Duplicados por territorio-periodo: no evaluables hasta identificar y normalizar las claves.


### Interpretación de la estructura
- **Filas Excel 1–6:** títulos, unidad y separadores; las columnas restantes están mayoritariamente vacías.
- **Fila Excel 7:** diferencia cuatro bloques de medidas: **Índice** (posición 1 de pandas), **variación mensual** (posición 298), **variación anual** (posición 595) y **variación en lo que va de año** (posición 892).
- **Fila Excel 8:** periodos mensuales de 2026M09 a 2002M01, repetidos dentro de cada bloque.
- **Desde la fila Excel 9:** bloques de **15 filas por territorio**: una fila con el territorio, una con el **Índice general** y trece con los grupos ECOICOP versión 2 (01–13). Asturias comienza en la fila 54. No son bloques de 13 filas: 13 es el número de grupos, al que se añaden el índice general y la cabecera territorial.
- **Columna A:** territorio o grupo de consumo; **resto de columnas:** valores mensuales correspondientes a cada una de las cuatro medidas.
- **Últimas filas:** notas y fuente, no observaciones.

**Unidad:** índice (base 2025) o porcentaje según la medida. **Granularidad futura:** territorio × categoría ECOICOP × mes × medida.

**Preparación prevista:** identificar los bloques de medidas, propagar la etiqueta territorial a cada categoría, convertir los meses de columnas a filas y separar/etiquetar índices y tasas sin mezclarlos.


## Salarios
Archivo: `salarios_raw.xlsx`

- Dimensiones originales: **50 filas × 19 columnas**.
- Lectura con `header=None` para no perder las filas informativas del INE.

### Vista de encabezados (primeras 12 filas, 5 columnas)
| Fila Excel aprox. | Columna 1 | Columna 2 | Columna 3 | Columna 4 | Columna 5 |
| --- | --- | --- | --- | --- | --- |
| 1 | Resultados nacionales y por comunidades aútonomas |  |  |  |  |
| 2 | Ganancia media anual por trabajador |  |  |  |  |
| 3 |  |  |  |  |  |
| 4 | Sexo y sectores de actividad |  |  |  |  |
| 5 | Unidades: € |  |  |  |  |
| 6 |  |  |  |  |  |
| 7 |  | Total Nacional | Andalucía | Aragón | Asturias, Principado de |
| 8 | Todos los sectores |  |  |  |  |
| 9 | 2024 |  |  |  |  |
| 10 | Ambos sexos | 29540.26 | 26089.7 | 28061.94 | 28562.31 |
| 11 | 2023 |  |  |  |  |
| 12 | Ambos sexos | 28049.94 | 25051.51 | 26822.32 | 27916.6 |

- Periodos en cabeceras: no detectados automáticamente; comprobar manualmente.

### Identificación de territorios y variables
- Etiquetas con Asturias en la primera columna: **0**.
- Etiquetas con España/Total Nacional en la primera columna: **2**.
- Ejemplos de etiquetas: `Ambos sexos`; `2023`; `Ambos sexos`; `2022`; `Ambos sexos`; `2021`; `Ambos sexos`; `2020`; `Ambos sexos`; `2019`; `Ambos sexos`; `2018`

### Comprobación de calidad (preliminar)
- Celdas vacías en toda la hoja: **581**.
- **No interpretar esas celdas como datos ausentes reales**: hay encabezados y separadores.
- Duplicados por territorio-periodo: no evaluables hasta identificar y normalizar las claves.
- Atención: las cifras señaladas con `-` pueden llevar una marca de fiabilidad estadística; revisar las notas del INE antes de convertirlas.


### Interpretación de la estructura
- **Filas Excel 1–6:** información descriptiva, unidades y separadores.
- **Fila Excel 7:** territorios en columnas, incluyendo el total nacional y Asturias.
- **Fila Excel 8:** ámbito sectorial: **Todos los sectores**.
- **Desde la fila Excel 9:** pares de filas: la primera identifica el **año** (2024, 2023, etc.) y la siguiente contiene los importes para **Ambos sexos**, por territorio. Se repite cada dos filas.
- **Últimas filas:** advertencias sobre fiabilidad de algunas estimaciones y fuente.

**Unidad:** euros brutos de ganancia media anual por trabajador. **Granularidad futura:** año × territorio (categoría 'Ambos sexos'; todos los sectores).

**Preparación prevista:** asociar cada fila de importes con el año anterior, conservar las etiquetas territoriales y convertir el conjunto a formato largo `anio | territorio | salario_medio_eur` para facilitar las uniones en SQL. La propuesta alternativa de una fila por año y territorio por columna es válida para visualizar, pero menos flexible para integrar las fuentes.

**Advertencia estadística:** el signo `-` delante de algunos importes no equivale a un salario negativo: señala una estimación de baja fiabilidad según la nota de la fuente. Mantener una marca de calidad al preparar esos valores.


## Valor tasado
Archivo: `tasa_raw.csv`

- Dimensiones: **13,711 filas × 8 columnas**.
- Columnas: `Año`, `Trimestre`, `Valor`, `Régimen`, `CPRO`, `Provincia`, `Comunidad_Autónoma`, `CODAUTO`

### Ejemplo de registros
| Año | Trimestre | Valor | Régimen | CPRO | Provincia | Comunidad_Autónoma | CODAUTO |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1995 | 1 |  | Libre |  | Ceuta y Melilla | Ceuta y Melilla | 0.0 |
| 1995 | 2 |  | Libre |  | Ceuta y Melilla | Ceuta y Melilla | 0.0 |
| 1995 | 3 |  | Libre |  | Ceuta y Melilla | Ceuta y Melilla | 0.0 |
| 1995 | 4 |  | Libre |  | Ceuta y Melilla | Ceuta y Melilla | 0.0 |
| 1996 | 1 |  | Libre |  | Ceuta y Melilla | Ceuta y Melilla | 0.0 |

### Tipos de datos
| Columna | Tipo inferido |
| --- | --- |
| Año | int64 |
| Trimestre | int64 |
| Valor | float64 |
| Régimen | object |
| CPRO | float64 |
| Provincia | object |
| Comunidad_Autónoma | object |
| CODAUTO | float64 |

### Valores ausentes por columna
| Columna | Nulos | % nulos |
| --- | --- | --- |
| Año | 0 | 0.0% |
| Trimestre | 0 | 0.0% |
| Valor | 844 | 6.2% |
| Régimen | 0 | 0.0% |
| CPRO | 3,535 | 25.8% |
| Provincia | 0 | 0.0% |
| Comunidad_Autónoma | 1 | 0.0% |
| CODAUTO | 425 | 3.1% |

- Filas exactamente duplicadas: **142**. Se encuentran, por ejemplo, repeticiones de valores de vivienda protegida para Navarra. **No eliminarlas sin verificar su origen y la clave de unicidad.**
- `Año`: 32 valores distintos; intervalo 1995–2026.
- `Trimestre`: 4 valores distintos.
- `Régimen`: 2 valores distintos; categorías: Libre, Protegida.
- `Comunidad_Autónoma`: 21 valores distintos.
- `Provincia`: 50 valores distintos.
- Registros de Asturias: **212**.



### Interpretación de la estructura
Es el único archivo del núcleo que **ya está en formato largo**: una observación por fila y ocho campos explícitos.

| Columna | Significado |
| --- | --- |
| `Año` | Año del valor tasado. |
| `Trimestre` | Trimestre del año (1 a 4). |
| `Valor` | Valor tasado medio por metro cuadrado, expresado en €/m². |
| `Régimen` | Vivienda `Libre` o `Protegida`. |
| `CPRO` | Código provincial, vacío en registros agregados. |
| `Provincia` | Provincia o etiqueta del agregado, como `Total CCAA`. |
| `Comunidad_Autónoma` | Comunidad autónoma asociada. |
| `CODAUTO` | Código de comunidad autónoma, que puede estar vacío en agregados. |

**Ejemplo real:** 1995T3, Asturias, régimen Libre, `Provincia = Total CCAA`, `Valor = 643,7` indica un valor tasado autonómico de **643,7 €/m²** para vivienda libre, no un precio de compraventa.

**Granularidad:** periodo × régimen × unidad geográfica. Los registros autonómicos se reconocen, entre otros criterios, por `Provincia = Total CCAA`; deben distinguirse de los provinciales y nacionales para evitar sumas/medias repetidas. En Asturias se encontraron **212 registros** de agregado autonómico: 126 de vivienda libre y 86 de protegida.

**Preparación prevista:** conservar la estructura larga, definir nivel territorial, identificar las filas de Asturias y del total nacional, preservar las categorías de régimen y revisar nulos y duplicados antes de decidir cualquier exclusión.

## Síntesis de la exploración

| Fuente | Forma original | Medidas relevantes | Transformación para el análisis |
| --- | --- | --- | --- |
| IPV | Territorios en bloques de 4 filas; trimestres repetidos en 4 bloques de columnas | Índice general, nueva y segunda mano; tasas diferenciadas | Etiquetar territorio/tipo/medida y pasar a formato largo |
| IPC | Territorios en bloques de 15 filas; meses repetidos en 4 bloques de columnas | Índice general y grupos ECOICOP v2; tasas diferenciadas | Etiquetar territorio/categoría/medida y pasar a formato largo |
| Salarios | Territorios en columnas; dos filas por año | Ganancia media anual de ambos sexos, todos los sectores | Asociar año con importes y pasar a formato largo |
| Valor tasado | CSV de 8 columnas, una observación por fila | €/m², vivienda libre/protegida | Mantener formato largo; seleccionar nivel geográfico y depurar |

### Comparabilidad temporal

- **IPV:** 2007T1–2026T2; **IPC:** 2002M01–2026M09; **salarios:** 2008–2024; **valor tasado:** registros desde 1995 hasta 2026 (con diferente disponibilidad según trimestre, territorio y régimen).
- **Periodo candidato común:** **2008–2024**, al anualizar correctamente las series trimestrales y mensuales. No equivale a afirmar que todas las combinaciones de categoría y territorio estén completas.
- Las fuentes se conservan inicialmente a sus frecuencias originales. Para comparar índices y salarios se elaborarán series anuales con una metodología explícita, sin hacer una unión directa entre meses, trimestres y años.
- **Ámbito prioritario:** Asturias, con España como referencia. Hay que definir una equivalencia estable para `Nacional`, `Total Nacional` y los agregados territoriales del CSV, y para `03 Asturias, Principado de` frente a `Asturias, Principado de`.

### Resultados de calidad e interpretación

- Los **nulos contabilizados en los Excel son conteos de celdas de las hojas originales** y engloban elementos de maquetación (etiquetas de territorio, notas y separadores). No se consideran pérdidas de datos hasta aislar el cuerpo numérico.
- El CSV de valor tasado contiene **844 valores ausentes en `Valor` (6,2 %)** y **142 filas idénticas duplicadas**; en él también pueden faltar códigos geográficos en registros agregados. La decisión de excluir o conservar registros debe hacerse según la clave territorial y la disponibilidad pertinente para Asturias/España.
- En salarios, las marcas `-` de fiabilidad se interpretarán según la nota oficial, no como signos negativos de renta.
- El **IPV mide la evolución del precio de compraventa**, el **IPC la evolución de los precios de consumo**, el **salario** es una ganancia bruta individual media y el **valor tasado €/m²** no es necesariamente el precio final pagado. No se mezclarán unidades ni se identificará valor tasado con compraventa.

### Decisiones de preparación documentadas

1. Conservar intactos todos los archivos en `data/raw/`.
2. Identificar cabeceras, medidas y observaciones antes de eliminar filas informativas o columnas vacías.
3. Convertir los tres Excel de estructura ancha a tablas largas con claves explícitas de territorio, periodo y categoría.
4. Mantener por separado **índices**, **variaciones porcentuales**, **salarios en euros** y **tasaciones en €/m²**.
5. Comprobar unicidad a nivel de **territorio × periodo × categoría × medida** (y, cuando proceda, régimen y nivel geográfico); no interpretar una fila duplicada sin esta clave.
6. Crear indicadores anuales comparables solo después de establecer la regla de agregación apropiada para cada serie.

**Alcance de este documento:** auditoría exploratoria de los archivos de partida. Las transformaciones propuestas están definidas, pero las validaciones sobre las tablas transformadas corresponden a la fase de limpieza; no se presentan como pruebas ya ejecutadas.
