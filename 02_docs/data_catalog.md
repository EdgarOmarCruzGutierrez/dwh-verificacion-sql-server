# Catálogo de datos de la capa Gold

## Descripción general
La capa Gold es la representación de los datos a nivel de negocio, estructurada para apoyar casos de uso analíticos y de reportes. Consta de **tablas de dimensión** y **tablas de hechos** para métricas de negocio específicas.

---

### 1. **gold.dim_customers**
- **Propósito:** almacena los datos de los clientes, enriquecidos con información demográfica y geográfica.
- **Columnas:**

| Columna          | Tipo de dato  | Descripción                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key     | INT           | Llave sustituta que identifica de forma única cada registro de cliente en la tabla de dimensión. |
| customer_id      | INT           | Identificador numérico único asignado a cada cliente.                                         |
| customer_number  | NVARCHAR(50)  | Identificador alfanumérico del cliente, usado para su seguimiento y referencia.               |
| first_name       | NVARCHAR(50)  | Nombre del cliente, tal como está registrado en el sistema.                                   |
| last_name        | NVARCHAR(50)  | Apellido del cliente.                                                                         |
| country          | NVARCHAR(50)  | País de residencia del cliente (por ejemplo, 'Australia').                                    |
| marital_status   | NVARCHAR(50)  | Estado civil del cliente (por ejemplo, 'Married', 'Single').                                  |
| gender           | NVARCHAR(50)  | Género del cliente (por ejemplo, 'Male', 'Female', 'n/a').                                    |
| birthdate        | DATE          | Fecha de nacimiento del cliente, con formato AAAA-MM-DD (por ejemplo, 1971-10-06).            |
| create_date      | DATE          | Fecha en que se creó el registro del cliente en el sistema.                                   |

---

### 2. **gold.dim_products**
- **Propósito:** proporciona información sobre los productos y sus atributos.
- **Columnas:**

| Columna             | Tipo de dato  | Descripción                                                                                   |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key         | INT           | Llave sustituta que identifica de forma única cada registro de producto en la tabla de dimensión. |
| product_id          | INT           | Identificador único asignado al producto para su seguimiento y referencia internos.           |
| product_number      | NVARCHAR(50)  | Código alfanumérico estructurado del producto, usado a menudo para categorización o inventario. |
| product_name        | NVARCHAR(50)  | Nombre descriptivo del producto, con datos clave como tipo, color y talla.                    |
| category_id         | NVARCHAR(50)  | Identificador único de la categoría del producto, que lo vincula con su clasificación general. |
| category            | NVARCHAR(50)  | Clasificación general del producto (por ejemplo, Bikes, Components) para agrupar artículos relacionados. |
| subcategory         | NVARCHAR(50)  | Clasificación más detallada del producto dentro de la categoría, como el tipo de producto.    |
| maintenance         | NVARCHAR(50)  | Indica si el producto requiere mantenimiento (por ejemplo, 'Yes', 'No').                      |
| cost                | INT           | Costo o precio base del producto, en unidades monetarias.                                     |
| product_line        | NVARCHAR(50)  | Línea o serie específica a la que pertenece el producto (por ejemplo, Road, Mountain).        |
| start_date          | DATE          | Fecha en que el producto estuvo disponible para la venta o el uso.                            |

---

### 3. **gold.fact_sales**
- **Propósito:** almacena los datos transaccionales de ventas con fines analíticos.
- **Columnas:**

| Columna         | Tipo de dato  | Descripción                                                                                   |
|-----------------|---------------|-----------------------------------------------------------------------------------------------|
| order_number    | NVARCHAR(50)  | Identificador alfanumérico único de cada pedido de venta (por ejemplo, 'SO54496').            |
| product_key     | INT           | Llave sustituta que vincula el pedido con la tabla de dimensión de productos.                 |
| customer_key    | INT           | Llave sustituta que vincula el pedido con la tabla de dimensión de clientes.                  |
| order_date      | DATE          | Fecha en que se realizó el pedido.                                                            |
| shipping_date   | DATE          | Fecha en que el pedido se envió al cliente.                                                   |
| due_date        | DATE          | Fecha límite de pago del pedido.                                                              |
| sales_amount    | INT           | Valor monetario total de la venta de la línea, en unidades monetarias enteras (por ejemplo, 25). |
| quantity        | INT           | Número de unidades del producto pedidas en la línea (por ejemplo, 1).                         |
| price           | INT           | Precio por unidad del producto en la línea, en unidades monetarias enteras (por ejemplo, 25). |
