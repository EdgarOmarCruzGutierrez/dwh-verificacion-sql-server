**Equipo:** Cruz Gutiérrez Edgar Omar y Rodriguez Muñoz Salma Annette

# Proyecto de Data Warehouse y Analítica

[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@datawithbaraa) [![Udemy](https://img.shields.io/badge/Udemy-A435F0?style=for-the-badge&logo=udemy&logoColor=white)](https://www.udemy.com/course/building-a-modern-data-warehouse-data-engineering-bootcamp/) [![Website](https://img.shields.io/badge/datawithbaraa.com-111111?style=for-the-badge&logo=googlechrome&logoColor=white)](https://www.datawithbaraa.com) [![License](https://img.shields.io/github/license/DataWithBaraa/sql-data-warehouse-project?style=for-the-badge&color=2EA043)](LICENSE) [![Stars](https://img.shields.io/github/stars/DataWithBaraa/sql-data-warehouse-project?style=for-the-badge&color=F5B301)](https://github.com/DataWithBaraa/sql-data-warehouse-project)

Los materiales del proyecto de data warehouse: los archivos de origen, todos los scripts de los videos y la documentación.

Se parte de archivos sin procesar de dos sistemas, un CRM y un ERP, y se construye un data warehouse en SQL Server. Al final, los datos quedan limpios y listos para analizarse.

**¿Eres nuevo aquí? Abre la guía de instalación en la carpeta `00_setup`.** Explica cómo instalar SQL Server y crear la base de datos, en Windows y Mac, con las soluciones a los errores más comunes (la guía está en inglés).

```
sql-data-warehouse-project/
├── 00_setup/               la guía de instalación y el inicio con un clic de Docker para Mac
├── 01_datasets/            los seis archivos de origen que carga el proyecto
│   ├── source_crm/         tres archivos del sistema CRM
│   └── source_erp/         tres archivos del sistema ERP
├── 02_docs/                los requisitos, los diagramas y las notas
├── 03_scripts/             los scripts del proyecto, en el orden de los videos
│   ├── init_database.sql   crea la base de datos: ejecútalo primero
│   ├── bronze/             carga los archivos sin procesar
│   ├── silver/             limpia y prepara los datos
│   └── gold/               construye las tablas para el análisis
├── 04_tests/               verifica la calidad de los datos de silver y gold
└── 05_verificacion/        verificación del warehouse en Docker: consultas, resultados y capturas
```

El proyecto lee los seis archivos desde `C:\sql\dwh_project\01_datasets\`. Coloca la carpeta ahí, o cambia las seis rutas en `03_scripts/bronze/proc_load_bronze.sql`. En los videos las carpetas aparecen sin números: `datasets` allí es `01_datasets` aquí, y `scripts` es `03_scripts`.

---
## 🏗️ Arquitectura de datos

La arquitectura de datos de este proyecto sigue la Arquitectura Medallón, con las capas **Bronze**, **Silver** y **Gold**:
![Arquitectura de datos](02_docs/data_architecture.png)

1. **Capa Bronze**: guarda los datos sin procesar, tal como vienen de los sistemas de origen. Los datos se ingieren desde archivos CSV a una base de datos de SQL Server.
2. **Capa Silver**: incluye los procesos de limpieza, estandarización y normalización para preparar los datos para el análisis.
3. **Capa Gold**: contiene los datos listos para el negocio, modelados en un esquema en estrella para reportes y analítica.

---
## 📖 Descripción del proyecto

En este proyecto:

1. **Diseñas la arquitectura:** un data warehouse moderno con tres capas, bronze, silver y gold.
2. **Construyes los pipelines ETL:** cargas los archivos de origen y mueves los datos a través de las capas.
3. **Modelas los datos:** hechos y dimensiones, listos para reportes.
4. **Los analizas:** respondes preguntas de negocio con SQL.

---

## 🛠️ Enlaces y herramientas importantes

- **SQL Server y SSMS:** la guía de instalación en `00_setup` tiene los enlaces y cada paso.
- **[Git](https://github.com/):** una cuenta de GitHub, para guardar y compartir tu proyecto.
- **[draw.io](https://www.drawio.com/):** para dibujar la arquitectura y el modelo de datos.
- **[Plantilla de Notion](https://www.notion.com/templates/sql-data-warehouse-project):** el plan del proyecto, listo para copiar.
- **[Pasos del proyecto en Notion](https://thankful-pangolin-2ca.notion.site/SQL-Data-Warehouse-Project-16ed041640ef80489667cfe2f380b269?pvs=4):** cada fase y tarea del proyecto.

---

## 🚀 Requisitos del proyecto

### Construcción del Data Warehouse (Ingeniería de Datos)

#### Objetivo
Desarrollar un data warehouse moderno con SQL Server para consolidar los datos de ventas, de modo que permita generar reportes analíticos y apoyar la toma de decisiones.

#### Especificaciones
- **Fuentes de datos**: importar datos de dos sistemas de origen (ERP y CRM) entregados como archivos CSV.
- **Calidad de datos**: depurar y resolver los problemas de calidad de datos antes del análisis.
- **Integración**: combinar ambas fuentes en un único modelo de datos fácil de usar, diseñado para consultas analíticas.
- **Alcance**: trabajar solo con el conjunto de datos más reciente; no se requiere historizar los datos.
- **Documentación**: entregar documentación clara del modelo de datos, que sirva tanto a las áreas de negocio como a los equipos de analítica.

---

### BI: Analítica y Reportes (Análisis de Datos)

#### Objetivo
Desarrollar análisis basados en SQL que aporten información detallada sobre:
- **Comportamiento de los clientes**
- **Desempeño de los productos**
- **Tendencias de ventas**

Estos hallazgos dan a las partes interesadas métricas clave del negocio para tomar decisiones estratégicas.  

Para más detalles, consulta [02_docs/requirements.md](02_docs/requirements.md).

---

## 05_verificacion

Verificación de este warehouse en SQL Server 2022 con Docker: `docker-compose.yml`, 8 consultas de comprobación (`sql/consultas_verificacion.sql`), sus resultados en CSV y capturas del proceso. Detalles y hallazgos en [`05_verificacion/README.md`](05_verificacion/README.md). `04_tests/smoke_tests.sql` es un complemento propio con conteos por capa.

---

## 🎓 Aprende con el autor original

Este proyecto es del curso de Data With Baraa. Puedes verlo en YouTube o tomar la versión guiada con certificado en su Academia o en Udemy (los sitios están en inglés).

| Curso | YouTube | Mi Academia | Udemy |
|:--|:--|:--|:--|
| **SQL** | [Full course](https://youtu.be/SSKVgrwhzus) · [Playlist](https://www.youtube.com/playlist?list=PLNcg_FV9n7qZY_2eAtUzEUulNjTJREhQe) | [Full Package](https://www.datawithbaraa.com/course/sql-full-course-for-beginners) · [Handbook](https://academy.datawithbaraa.com/l/digital_download/1087406/the-sql-handbook) | [SQL Bootcamp](https://www.udemy.com/course/the-complete-sql-bootcamp-30-hours-go-from-zero-to-hero/?referralCode=D20781228C2EB8B98339) · [SQL for Analytics](https://www.udemy.com/course/sql-mastery-for-data-analytics-and-business-intelligence/) |
| **Python** | [Full course](https://youtu.be/Rq5gJVxz55Q) · [Playlist](https://www.youtube.com/playlist?list=PLNcg_FV9n7qZGfFl2ANI_zISzNp257Lwn) | [Full Package](https://www.datawithbaraa.com/course/the-ultimate-python-mastery) · [Handbook](https://academy.datawithbaraa.com/l/digital_download/998313/the-python-handbook) | [Python Bootcamp](https://www.udemy.com/course/the-complete-python-bootcamp-13hours-go-from-zero-to-hero/?referralCode=776491A4119FF8AF41CA) |
| **Tableau** | [Full course](https://youtu.be/K3pXnbniUcM) · [Playlist](https://www.youtube.com/playlist?list=PLNcg_FV9n7qZJqrKcUUCWCWPYCrlcVm9v) | [Full Package](https://www.datawithbaraa.com/course/tableau-ultimate-full-course-for-beginners) | [Tableau Course](https://www.udemy.com/course/the-tableau-ultimate-course-from-zero-to-hero/?referralCode=6544726FDC491A6B25EC) · [Chart Masterclass](https://www.udemy.com/course/the-tableau-ultimate-chart-masterclass-63-tableau-charts/) |
| **Power BI** | [Full course](https://www.youtube.com/playlist?list=PLNcg_FV9n7qZge4KDGqGtqgiuVuhVZWzu) | | |
| **Databricks** | [Full course](https://www.youtube.com/playlist?list=PLNcg_FV9n7qZWchr-GE5iPPBmOjiffK6O) | | |

Materiales en su sitio web: [SQL](https://www.datawithbaraa.com/wiki/sql) · [Python](https://www.datawithbaraa.com/wiki/python) · [Tableau](https://www.datawithbaraa.com/wiki/tableau) · [Power BI](https://www.datawithbaraa.com/wiki/power-bi)

### Los proyectos de SQL

| Proyecto | YouTube | Materiales | Udemy |
|:--|:--|:--|:--|
| **Data Warehouse** | [Ver](https://youtu.be/9GVqKuTVANE) | este repositorio | [Building a Modern Data Warehouse](https://www.udemy.com/course/building-a-modern-data-warehouse-data-engineering-bootcamp/) |
| **Análisis Exploratorio de Datos** | [Ver](https://youtu.be/6cJ5Ji8zSDg) | [Repositorio](https://github.com/DataWithBaraa/sql-data-analytics-project) | [SQL for Exploratory Data Analysis](https://www.udemy.com/course/sql-for-exploratory-data-analysis-eda-real-world-project/) |
| **Analítica de Datos Avanzada** | [Ver](https://youtu.be/2jGhQpbzHes) | el mismo repositorio | |

Más en YouTube: [Proyectos de datos](https://www.youtube.com/playlist?list=PLNcg_FV9n7qZ4Ym8ZriYT6WF8TaC2e_R7) · [Carreras en datos](https://www.youtube.com/playlist?list=PLNcg_FV9n7qah95jp-aPtysu7kFCbg7hd)

## 🤝 Contacto del autor original

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge)](https://www.linkedin.com/in/baraa-khatib-salkini/) [![Discord](https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/gsVJbMxKcA) [![Instagram](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/datawithbaraa/) [![TikTok](https://img.shields.io/badge/TikTok-000000?style=for-the-badge&logo=tiktok&logoColor=white)](https://www.tiktok.com/@datawithbaraa) [![Newsletter](https://img.shields.io/badge/Newsletter-FF6719?style=for-the-badge&logo=substack&logoColor=white)](https://www.blog.datawithbaraa.com) [![Notion Roadmaps](https://img.shields.io/badge/Notion_Roadmaps-000000?style=for-the-badge&logo=notion&logoColor=white)](https://www.notion.com/@datawithbaraa)

## 🛡️ Licencia

[MIT](LICENSE). Úsalo, cámbialo y compártelo, con atribución.

## 🌟 Sobre el autor original

Proyecto original de **Baraa Khatib Salkini** (Data With Baraa): [github.com/DataWithBaraa/sql-data-warehouse-project](https://github.com/DataWithBaraa/sql-data-warehouse-project). Pasó años en ingeniería de datos empresarial y construyó uno de los lakehouses más grandes de Mercedes-Benz. Hoy enseña datos de tiempo completo en **Data With Baraa**: de forma visual, paso a paso, de cero a experto.
