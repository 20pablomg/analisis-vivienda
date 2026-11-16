# Análisis del mercado de vivienda en Asturias

Proyecto de análisis de datos sobre la evolución de los precios de compraventa de vivienda en Asturias y su relación con la inflación, los salarios y el valor tasado. Se compara Asturias con el conjunto de España y la Comunidad de Madrid.

**Estado:** limpieza y análisis SQL del núcleo completados; visualización en Power BI y ampliaciones pendientes.

## Preguntas de análisis

1. ¿Cuánto ha variado el precio de la vivienda desde 2007 y cómo se compara Asturias con España?
2. ¿Ha crecido el precio de la vivienda por encima de la inflación? ¿Cómo influye el año de partida?
3. ¿Han crecido los salarios al mismo ritmo que el precio de la vivienda entre 2008 y 2024?
4. ¿Cómo ha evolucionado el valor tasado por metro cuadrado? ¿A cuántos salarios brutos anuales equivale el valor estimado de una vivienda de 80 m²?

El análisis principal se centra en estas cuatro preguntas. Las extensiones relativas a inflación, salarios y accesibilidad se desarrollan dentro de ellas.

## Fuentes y datos

| Tabla SQLite | Fuente e indicador | Frecuencia | Periodo disponible | Registros |
|---|---|---|---|---:|
| `ipv` | INE, Índice de Precios de Vivienda (base 2025) | Trimestral | 2007T1–2026T2 | 4.680 |
| `ipc` | INE, Índice de Precios de Consumo (base 2025) | Mensual | 2002M01–2026M09 | 83.160 |
| `salarios` | INE, ganancia media anual bruta por trabajador | Anual | 2008–2024 | 306 |
| `tasa` | Estadística oficial del valor tasado de vivienda libre (€/m²) | Trimestral | 1995–2026T2 | 2.520 |

Los datos del núcleo contienen **90.666 registros** tras la limpieza. Las series tienen distinta cobertura y frecuencia, por lo que cada comparación utiliza exclusivamente periodos comunes.

## Herramientas

- **Python y pandas:** exploración, transformación y validación de los datos.
- **SQLite y SQL:** almacenamiento, consultas, agregaciones, vistas y comparación de indicadores.
- **VS Code y Jupyter Notebook:** desarrollo y documentación del proceso.
- **Power BI:** próxima fase de visualización interactiva.

## Organización del proyecto

```text
analisis-vivienda/
├── data/
│   ├── raw/core/              # Cuatro fuentes originales del núcleo
│   ├── processed/core/        # CSV limpios: ipv, ipc, salarios y tasa
│   └── vivienda.db            # Base SQLite generada localmente
├── notebooks/
│   └── limpieza_core.ipynb
├── sql/
│   ├── 01_crear_tablas.sql
│   └── 02_analisis.sql
├── docs/
│   ├── informe_limpieza.md
│   └── informe_analisis_sql.md
└── ruta.md
```

Las carpetas de ampliaciones y otros archivos auxiliares no se muestran aquí. La base `.db` es un archivo generado y no es necesario incluirla en Git.

## Flujo de trabajo

1. **Fuentes:** situar los cuatro archivos originales del núcleo en `data/raw/core/` con estos nombres: `base25_raw.xlsx`, `ipcgrupos_raw.xlsx`, `salarios_raw.xlsx` y `tasa_raw.csv`.
2. **Limpieza:** ejecutar `notebooks/limpieza_core.ipynb` desde la carpeta `notebooks/`. Genera `data/processed/core/ipv.csv`, `ipc.csv`, `salarios.csv` y `tasa.csv`.
3. **Base de datos:** crear las tablas de SQLite con `sql/01_crear_tablas.sql` y cargar en ellas los CSV procesados mediante el procedimiento de importación del proyecto.
4. **Consultas:** ejecutar `sql/02_analisis.sql` con la conexión SQLite configurada. El script crea vistas reutilizables y devuelve los resultados de las cuatro preguntas.
5. **Interpretación:** consultar `docs/informe_analisis_sql.md` para fórmulas, periodos y limitaciones.

**Entorno de Python:** pandas, openpyxl y Jupyter; `sqlite3` forma parte de la biblioteca estándar. La automatización de la creación y carga completa de la base en un solo comando es una posible mejora posterior, si todavía no se ha incorporado al repositorio.

## Hallazgos del análisis principal

Con los datos utilizados en esta versión:

- Entre **2007T1 y 2026T2**, el IPV general de Asturias aumentó **31,63 %** y el IPC general **48,86 %**. El cambio del IPV descontando la inflación fue **−11,57 %**.
- La interpretación depende del periodo inicial: el IPV subió con mucha más intensidad al tomar como referencia 2014 o 2020, después de la crisis inmobiliaria.
- El valor tasado estimado de una vivienda de **80 m²** en Asturias equivalía a **6,49 salarios brutos anuales medios en 2008** y **3,97 en 2024**. Es una equivalencia estadística, **no años necesarios para ahorrar o comprar**.

Estos resultados describen las fuentes y periodos indicados; no permiten concluir por sí solos cuál es el precio efectivo de una vivienda concreta ni la capacidad de compra de todos los hogares.

## Decisiones metodológicas

- Para comparar IPV trimestral e IPC mensual se emplea el promedio del IPC de los tres meses de cada trimestre.
- Para comparar con salarios anuales se utilizan medias anuales del IPV y del valor tasado por m².
- Se distingue entre el crecimiento **nominal** del IPV y su crecimiento **real**, calculado mediante el cociente de los factores de crecimiento del IPV y del IPC general.
- El IPC de alimentos se utiliza como contraste complementario, no como sustituto del IPC general.
- El valor tasado no equivale al precio final de compraventa y el salario bruto individual no equivale a la renta neta de un hogar.

## Próximos pasos

- Construir visualizaciones y un panel interactivo en **Power BI**.
- Incorporar, en una fase posterior, otras fuentes que permitan estudiar dimensiones adicionales del mercado de vivienda.
