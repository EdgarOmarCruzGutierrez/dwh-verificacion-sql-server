# Requisitos del proyecto

Hay una versión en PDF de una página de este documento en [Project_Requirements.pdf](Project_Requirements.pdf) (en inglés).

## Construcción del Data Warehouse (Ingeniería de Datos)

### Objetivo
Desarrollar un data warehouse moderno con SQL Server para consolidar los datos de ventas, de modo que permita generar reportes analíticos y apoyar la toma de decisiones.

### Especificaciones
- **Fuentes de datos**: importar datos de dos sistemas de origen (ERP y CRM) entregados como archivos CSV.
- **Calidad de datos**: depurar y resolver los problemas de calidad de datos antes del análisis.
- **Integración**: combinar ambas fuentes en un único modelo de datos fácil de usar, diseñado para consultas analíticas.
- **Alcance**: trabajar solo con el conjunto de datos más reciente; no se requiere historizar los datos.
- **Documentación**: entregar documentación clara del modelo de datos, que sirva tanto a las áreas de negocio como a los equipos de analítica.

---

## BI: Analítica y Reportes (Análisis de Datos)

### Objetivo
Desarrollar análisis basados en SQL que aporten información detallada sobre:
- **Comportamiento de los clientes**
- **Desempeño de los productos**
- **Tendencias de ventas**

Estos hallazgos dan a las partes interesadas métricas clave del negocio para tomar decisiones estratégicas.
