# **Convenciones de nombres**

Este documento describe las convenciones de nombres usadas para esquemas, tablas, vistas, columnas y otros objetos del data warehouse.

## **Tabla de contenido**

1. [Principios generales](#principios-generales)
2. [Convenciones para nombres de tablas](#convenciones-para-nombres-de-tablas)
   - [Reglas de Bronze](#reglas-de-bronze)
   - [Reglas de Silver](#reglas-de-silver)
   - [Reglas de Gold](#reglas-de-gold)
3. [Convenciones para nombres de columnas](#convenciones-para-nombres-de-columnas)
   - [Llaves sustitutas](#llaves-sustitutas)
   - [Columnas técnicas](#columnas-técnicas)
4. [Procedimientos almacenados](#procedimientos-almacenados)
---

## **Principios generales**

- **Convención**: usar snake_case, con letras minúsculas y guiones bajos (`_`) para separar palabras.
- **Idioma**: usar inglés para todos los nombres.
- **Evitar palabras reservadas**: no usar palabras reservadas de SQL como nombres de objetos.

## **Convenciones para nombres de tablas**

### **Reglas de Bronze**
- Todos los nombres deben comenzar con el nombre del sistema de origen, y los nombres de las tablas deben coincidir con los originales, sin renombrarlos.
- **`<sistemaorigen>_<entidad>`**  
  - `<sistemaorigen>`: nombre del sistema de origen (por ejemplo, `crm`, `erp`).  
  - `<entidad>`: nombre exacto de la tabla en el sistema de origen.  
  - Ejemplo: `crm_customer_info` → información de clientes del sistema CRM.

### **Reglas de Silver**
- Todos los nombres deben comenzar con el nombre del sistema de origen, y los nombres de las tablas deben coincidir con los originales, sin renombrarlos.
- **`<sistemaorigen>_<entidad>`**  
  - `<sistemaorigen>`: nombre del sistema de origen (por ejemplo, `crm`, `erp`).  
  - `<entidad>`: nombre exacto de la tabla en el sistema de origen.  
  - Ejemplo: `crm_customer_info` → información de clientes del sistema CRM.

### **Reglas de Gold**
- Todos los nombres de tablas deben ser significativos y alineados con el negocio, y comenzar con el prefijo de categoría.
- **`<categoría>_<entidad>`**  
  - `<categoría>`: describe el rol de la tabla, como `dim` (dimensión) o `fact` (tabla de hechos).  
  - `<entidad>`: nombre descriptivo de la tabla, alineado con el dominio de negocio (por ejemplo, `customers`, `products`, `sales`).  
  - Ejemplos:
    - `dim_customers` → tabla de dimensión de clientes.  
    - `fact_sales` → tabla de hechos con las transacciones de ventas.  

#### **Glosario de patrones de categoría**

| Patrón      | Significado                       | Ejemplo(s)                              |
|-------------|-----------------------------------|-----------------------------------------|
| `dim_`      | Tabla de dimensión               | `dim_customer`, `dim_product`           |
| `fact_`     | Tabla de hechos                  | `fact_sales`                            |
| `report_`   | Tabla de reporte                 | `report_customers`, `report_sales_monthly`   |

## **Convenciones para nombres de columnas**

### **Llaves sustitutas**  
- Todas las llaves primarias de las tablas de dimensión deben usar el sufijo `_key`.
- **`<nombre_tabla>_key`**  
  - `<nombre_tabla>`: nombre de la tabla o entidad a la que pertenece la llave.  
  - `_key`: sufijo que indica que la columna es una llave sustituta.  
  - Ejemplo: `customer_key` → llave sustituta de la tabla `dim_customers`.
  
### **Columnas técnicas**
- Todas las columnas técnicas deben comenzar con el prefijo `dwh_`, seguido de un nombre descriptivo que indique su propósito.
- **`dwh_<nombre_columna>`**  
  - `dwh`: prefijo exclusivo para metadatos generados por el sistema.  
  - `<nombre_columna>`: nombre descriptivo que indica el propósito de la columna.  
  - Ejemplo: `dwh_create_date` → columna generada por el sistema que guarda la fecha en que el registro se cargó al warehouse.
 
## **Procedimientos almacenados**

- Todos los procedimientos almacenados que cargan datos deben seguir el patrón de nombre:
- **`load_<capa>`**.
  
  - `<capa>`: representa la capa que se carga, como `bronze`, `silver` o `gold`.
  - Ejemplo: 
    - `load_bronze` → procedimiento almacenado que carga datos en la capa Bronze.
    - `load_silver` → procedimiento almacenado que carga datos en la capa Silver.
