# Fuentes de datos

Inventario de las series utilizadas en el proyecto, con su origen, cobertura y limitaciones conocidas.

- **Fecha de descarga:** 28/10/2026
- **Fuente principal:** Instituto Nacional de Estadística (INE), salvo que se indique otra.
- **Convención de estado:**
  - **Núcleo:** incluida en el repositorio y usada en la Fase 1.
  - **Ampliación:** descargada, se incorporará al repositorio en fases posteriores.
  - **Pendiente:** todavía sin datos.

Los identificadores de tabla del INE son los que figuran en el nombre de la hoja de cada fichero descargado (por ejemplo, `tabla-79563`). Pueden localizarse en INEbase buscando el número.

## Núcleo (Fase 1)

| Serie | Organismo | Tabla | Periodicidad | Cobertura | Territorio | Archivo |
|---|---|---|---|---|---|---|
| Índice de Precios de Vivienda (IPV), base 2025: general, vivienda nueva y de segunda mano | INE | 79563 | Trimestral | 2007T1 – 2026T2 | Nacional y CCAA | `data/raw/ipv/base25_raw.xlsx` |
| Índice de Precios de Consumo (IPC), base 2025: general y grupos ECOICOP v2 | INE | 76136 | Mensual | 2002M01 – 2026M09 | CCAA | `data/raw/ipc/ipcgrupos_raw.xlsx` |
| Ganancia media anual por trabajador, por sexo y sector de actividad | INE | 28192 | Anual | 2008 – 2024 | Nacional y CCAA | `data/raw/salarios/salarios_raw.xlsx` |
| Valor tasado de la vivienda (€/m²), libre y protegida | Ministerio de Vivienda y Agenda Urbana | — | Trimestral | 1995 – 2026T2 | Provincias y CCAA | `data/raw/precio_m2/tasa_raw.csv` |

## Ampliaciones (descargadas, aún no incorporadas al repositorio)

**Demanda**

| Serie | Tabla INE | Periodicidad | Cobertura | Archivo |
|---|---|---|---|---|
| Hipotecas constituidas sobre fincas (número e importe) | 13896 | Mensual | 2003M01 – 2026M08 | `data/raw/hipotecas/hipotecas_raw.xlsx` |
| Compraventa de viviendas, por régimen y estado (ETDP) | 6150 | Mensual | 2007M01 – 2026M08 | `data/raw/compraventas/compraventa_raw.xlsx` |
| Población residente por fecha, sexo y edad | 56940 | Anual | 1971 – 1 ene 2025 | `data/raw/poblacion/poblacion_raw.xlsx` |
| Hogares en viviendas familiares, por tamaño del hogar | 60131 | Trimestral | 2021 – 2026 | `data/raw/hogares/hogares_raw.xlsx` |

**Oferta**

| Serie | Organismo | Periodicidad | Cobertura | Archivo |
|---|---|---|---|---|
| Vivienda iniciada y terminada, por provincia | Ministerio de Vivienda y Agenda Urbana | Mensual | 2008 – 2026-06 | `data/raw/construccion/construccion_raw.csv` |
| Vivienda iniciada y terminada, serie histórica | Ministerio de Vivienda y Agenda Urbana | Mensual y anual | 2002 – 2026-03 | `data/raw/construccion/construccion_historica_raw.tsv` |

**Turismo**

| Serie | Tabla INE | Periodicidad | Cobertura | Archivo |
|---|---|---|---|---|
| Viviendas turísticas y plazas | 39364 | Semestral (irregular) | 2020M08 – 2026M05 | `data/raw/apartamentos_turisticos/viviendas_raw.xlsx` |
| Porcentaje de viviendas turísticas sobre el total de viviendas | 39365 | Semestral (irregular) | 2020M08 – 2026M05 | `data/raw/apartamentos_turisticos/porcentajeviviendas_raw.xlsx` |
| Encuesta de ocupación en apartamentos turísticos | 2021 | Mensual | 2000M01 – 2026M08 | `data/raw/apartamentos_turisticos/apartamentos_raw.xlsx` |
| Viajeros y pernoctaciones en apartamentos turísticos | 1993 | Mensual | 2000M01 – 2026M08 | `data/raw/apartamentos_turisticos/viajeros_raw.xlsx` |

**Alquiler**

| Serie | Tabla INE | Periodicidad | Cobertura | Archivo |
|---|---|---|---|---|
| Índice de Precios de Vivienda en Alquiler (IPVA), general y por tipo de edificación | 59056 | Anual | 2011 – 2024 | `data/raw/ipva/ipva_raw.xlsx` |
| IPC por subgrupos ECOICOP v2, base 2025 | 76137 | Mensual | 2002M01 – 2026M09 | `data/raw/ipc/ipcsubgrupos_raw.xlsx` |

## Pendientes

- **Alquiler en euros.** Sin fuente incorporada todavía (carpeta `data/raw/alquiler_euros/` vacía).
- **Titularidad de viviendas (Catastro): sociedades y grandes tenedores.** Sin datos. Las cifras publicadas en prensa no se han podido contrastar con la fuente primaria, así que no se usan en el análisis hasta localizarla.

## Notas de calidad y limitaciones conocidas

1. **Formato ancho en los Excel del INE.** Los periodos van en columnas, en orden descendente y repetidos por cada medida. El primer paso de la limpieza es pasarlos a formato largo.
2. **Nombres de comunidades inconsistentes** entre fuentes (por ejemplo, `03 Asturias, Principado de`, `Asturias, Principado de` y `Principado de Asturias`). Se usará una tabla de comunidades con su código para enlazar las series.
3. **Salarios:** un signo `-` delante de la cifra indica que la muestra tiene entre 100 y 500 observaciones y que el dato es poco fiable. **No significa que el valor sea negativo.**
4. **IPVA:** al proceder de fuentes tributarias, excluye Navarra y País Vasco.
5. **Datos provisionales:** hipotecas y compraventas desde enero de 2026; apartamentos turísticos desde enero de 2026; hogares desde abril de 2021.
6. **Cortes temporales distintos** entre series (IPC a septiembre de 2026, hipotecas a agosto, salarios e IPVA a 2024). Hay que fijar un periodo común para las comparaciones.
7. **Base 2025** en IPV e IPC: no deben mezclarse con series publicadas en otras bases sin comprobar cómo las enlaza el INE.
8. **Valor tasado (`tasa_raw.csv`):** separador `;` y 844 valores vacíos (sobre todo en Castilla y León y en Ceuta y Melilla).
9. **Construcción (`construccion_raw.csv`):** la columna `TIPO_VIVIENDA` contiene `Libres` y `Libre` con el mismo número de filas. Comprobar si son duplicados antes de agregar.
10. **Turismo:** el porcentaje de viviendas turísticas desde 2023 usa como denominador el Censo de Población y Viviendas de 2021.

## Fuentes de contexto

- La Voz de Asturias, 28/09/2026: [Asturias es una de las comunidades con menor presencia de grandes fondos de vivienda](https://www.lavozdeasturias.es/noticia/asturias/2026/09/28/asturias-comunidades-menor-presencia-grandes-fondos-vivienda/00031790598590395194615.htm). **Fuente secundaria.** Se usa como referencia, no como dato.

## Cita

Instituto Nacional de Estadística (INE). INEbase: https://www.ine.es