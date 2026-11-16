
# Informe de análisis SQL — Mercado de vivienda en Asturias

## 1. Objetivo

Analizar la evolución del mercado de vivienda en Asturias y compararla con el conjunto de España y la Comunidad de Madrid. El estudio relaciona los precios de compraventa de viviendas, la inflación, los salarios brutos medios y el valor tasado por metro cuadrado.

El análisis se organiza en cuatro preguntas, recogidas en `ruta.md`. Las preguntas generales A, B y C quedan integradas en estas cuatro cuestiones, sin necesidad de duplicar consultas.

## 2. Datos y estructura

Se trabaja con una base de datos SQLite (`data/vivienda.db`, generada localmente) y cuatro tablas alimentadas desde datos previamente limpiados:

| Tabla | Indicador | Frecuencia | Uso en el análisis |
| --- | --- | --- | --- |
| `ipv` | Índice de Precios de Vivienda (IPV) | Trimestral | Evolución relativa de los precios de compraventa |
| `ipc` | Índice de Precios de Consumo (IPC) | Mensual | Inflación general y grupos de consumo |
| `salarios` | Salario medio bruto anual | Anual | Evolución de los ingresos laborales |
| `tasa` | Valor tasado de vivienda libre (€/m²) | Trimestral | Estimación del valor de una vivienda |

La creación de tablas y sus restricciones se recoge en `sql/01_crear_tablas.sql`; las consultas de análisis están en `sql/02_analisis.sql`. La limpieza y carga se realizaron con Python y se documentan por separado.

**Ámbito territorial principal:** Principado de Asturias, total nacional y Comunidad de Madrid. Para clasificar la inflación por comunidades se incluyen las 17 comunidades autónomas, excluyendo el total nacional, Ceuta y Melilla.

## 3. Preparación para el análisis

### 3.1. Vistas reutilizables

El script crea vistas con `DROP VIEW IF EXISTS` y `CREATE VIEW` para poder ejecutar el análisis repetidamente:

- `comparacion_ipv`: extrae el IPV general en 2007T1 y 2026T2 por territorio.
- `comparacion_ipc`: obtiene valores del IPC general correspondientes a esos mismos trimestres, tras promediar los tres índices mensuales de cada trimestre.
- `tasa_anual`: calcula el valor tasado medio anual de vivienda libre entre 2008 y 2024, por territorio.

En la versión ampliada del análisis puede utilizarse también una vista trimestral del IPC para reutilizar el cálculo en diferentes periodos y grupos de consumo. Las vistas guardan definiciones de consultas; no duplican las filas originales.

### 3.2. Comparabilidad temporal

- **IPV e IPC:** se comparan los mismos trimestres, 2007T1 y 2026T2. Para el IPC se usa el promedio de los tres meses de cada trimestre.
- **IPV y salarios:** se utiliza el IPV medio anual y se comparan 2008 y 2024, periodo común con los salarios disponibles.
- **Tasaciones y salarios:** se calcula la media anual del valor tasado por m² para compararla con el salario bruto medio anual del mismo año.

No se comparan directamente los valores absolutos de IPV e IPC: son índices. Se comparan sus **variaciones relativas**.

## 4. Preguntas de investigación

### Pregunta 1. ¿Cuánto se ha encarecido la vivienda desde 2007?

Se filtra `tipo_vivienda = 'General'` y se obtiene la variación acumulada del IPV entre 2007T1 y 2026T2:

**Variación del IPV (%):**

```math
\text{Variación IPV (\%)} =
100\left(\frac{IPV_f}{IPV_i}-1\right)
```

La consulta permite comparar Asturias con España y Madrid.

Para contextualizar el resultado se incorporan periodos alternativos con inicio en **2014T1** y **2020T1**, manteniendo 2026T2 como final.

Esta comparación es importante porque 2007 se sitúa antes de la caída del mercado inmobiliario; un incremento reciente elevado puede coexistir con un incremento acumulado más moderado desde ese año.

### Pregunta 2. ¿Ha aumentado el precio de la vivienda más que la inflación?

Se utiliza el **IPC general** como indicador principal del nivel agregado de precios.

La comparación parte de los factores de crecimiento de ambos índices:

**Factor de crecimiento del IPV:**

```math
F_{IPV}=\frac{IPV_f}{IPV_i}
```

**Factor de crecimiento del IPC:**

```math
F_{IPC}=\frac{IPC_f}{IPC_i}
```

Para estimar el cambio del IPV **en términos reales**, descontando la inflación general, se calcula:

**Variación real del IPV (%):**

```math
\text{Variación real del IPV (\%)} =
100\left(\frac{F_{IPV}}{F_{IPC}}-1\right)
```

Un valor positivo indica que el IPV ha aumentado más que el nivel general de precios; uno negativo indica que ha evolucionado por debajo de la inflación.

También se analiza si Asturias presenta una inflación especialmente elevada frente al resto de las comunidades autónomas, ordenándolas por su variación acumulada del IPC general.

**Análisis complementario:** se compara la evolución del IPV con el grupo del IPC de **alimentos y bebidas no alcohólicas**, sin sustituir el IPC general.

La inflación de los alimentos describe una cesta de productos, no el precio de un artículo particular, como una barra de pan.

### Pregunta 3. ¿Han crecido los salarios al ritmo de los precios de la vivienda?

Se comparan las variaciones acumuladas del **IPV general medio anual** y del **salario bruto medio anual** entre **2008 y 2024**.

La diferencia entre ambas tasas de variación se expresa en **puntos porcentuales**:

**Diferencia (puntos porcentuales):**

```math
\Delta_{\mathrm{pp}} =
\text{Variación IPV (\%)} -
\text{Variación salarial (\%)}
```

Esta medida identifica qué indicador ha crecido más durante el periodo.

No equivale por sí sola al cambio de la capacidad de compra de un hogar.

### Pregunta 4. ¿Cómo ha evolucionado el valor tasado y qué representa respecto al salario?

Se analiza el valor tasado medio de vivienda libre (€/m²) entre **2008 y 2024** y se compara con los salarios medios del mismo periodo.

Para ofrecer una magnitud interpretable se estima el valor de una vivienda de **80 m²**:

**Valor estimado de una vivienda de 80 m²:**

```math
P_{80} = 80 \times \overline{V}_{m^2}
```

Donde la variable `V` representa el valor tasado medio por metro cuadrado.

Se calcula su equivalencia en salarios brutos medios anuales:

**Número de salarios anuales:**

```math
N_{\mathrm{salarios}} =
\frac{P_{80}}{\overline{S}}
```

Donde `S` representa el salario bruto medio anual.

Este indicador se obtiene para **2008, 2012, 2016, 2020 y 2024**, por territorio.

La unión entre ambas fuentes utiliza conjuntamente `territorio` y `anio`.

## 5. Recursos de SQL utilizados

- `WHERE`, `IN` y `BETWEEN` para delimitar territorios, periodos y categorías.
- `GROUP BY`, `AVG` y `MAX(CASE WHEN ...)` para agregaciones y selección de valores iniciales y finales.
- `WITH` (CTE) para separar fases de cálculo.
- `CREATE VIEW` para reutilizar transformaciones.
- `INNER JOIN` para combinar indicadores del mismo territorio y periodo.
- `NULLIF` para evitar divisiones por cero.
- `ROUND` para presentar resultados.
- `RANK() OVER (...)` para clasificar las comunidades por inflación acumulada.

## 6. Comprobaciones recomendadas

Al ejecutar `sql/02_analisis.sql` sobre la base de datos real:

1. Confirmar que las vistas se crean sin errores.
2. Comprobar que las comparaciones principales producen **tres territorios** y no contienen valores nulos inesperados.
3. Confirmar que el ranking de inflación incluye **17 comunidades autónomas**.
4. Confirmar que la consulta de 80 m² ofrece **15 observaciones**: tres territorios por cinco años.
5. Verificar que la tabla de salarios y la de tasaciones coinciden en `territorio` y `anio` antes de calcular ratios.
6. Examinar la sensibilidad al periodo inicial (2007, 2014 y 2020), en lugar de interpretar una única variación acumulada como la historia completa del mercado.

## 7. Limitaciones e interpretación

- **IPV:** mide la evolución relativa del precio de compraventa, no el coste en euros de una vivienda específica.
- **IPC general:** mide el nivel general de precios de consumo; el IPC de alimentos no debe utilizarse como sustituto arbitrario.
- **Valor tasado (€/m²):** no equivale necesariamente al precio efectivo de venta ni al precio ofertado en anuncios.
- **Vivienda de 80 m²:** es una estimación simplificada construida con una superficie fija y valores tasados medios.
- **Salarios:** se usan salarios brutos medios individuales, no ingresos netos ni renta disponible de los hogares.
- **Número de salarios anuales:** expresa una equivalencia entre valor e ingresos. **No son años reales necesarios para ahorrar o comprar**, porque no incorpora gastos de vida, ahorro, entrada, intereses, impuestos ni financiación.
- **Comparaciones históricas:** las conclusiones dependen del año de referencia; el análisis debe mostrar tanto el recorrido largo desde 2007 como la evolución reciente.

## 8. Reproducibilidad y siguientes etapas

El análisis está diseñado para ejecutarse de nuevo sobre la base SQLite después de reconstruir las tablas desde los datos procesados.

Los archivos SQL, el notebook de limpieza y la documentación se versionan en Git; el archivo `.db` puede mantenerse fuera del repositorio.

**Siguiente etapa:** usar los resultados y/o las tablas preparadas como base para gráficos e interpretación en Power BI.

Las posibles ampliaciones del proyecto pueden añadirse posteriormente sin alterar estas preguntas principales.
