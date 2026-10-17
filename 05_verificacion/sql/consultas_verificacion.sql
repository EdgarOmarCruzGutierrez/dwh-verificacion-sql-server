/*
Consultas básicas de verificación del Data Warehouse (bronze -> silver -> gold).
Cada consulta empieza con un marcador "-- Qnn: nombre"; ejecutar.sh genera un CSV por consulta.
*/
USE DataWarehouse;

-- Q01: conteo_filas_por_capa
SELECT 'bronze' AS capa, 'crm_cust_info' AS tabla, COUNT(*) AS filas FROM bronze.crm_cust_info
UNION ALL SELECT 'bronze', 'crm_prd_info',      COUNT(*) FROM bronze.crm_prd_info
UNION ALL SELECT 'bronze', 'crm_sales_details', COUNT(*) FROM bronze.crm_sales_details
UNION ALL SELECT 'bronze', 'erp_cust_az12',     COUNT(*) FROM bronze.erp_cust_az12
UNION ALL SELECT 'bronze', 'erp_loc_a101',      COUNT(*) FROM bronze.erp_loc_a101
UNION ALL SELECT 'bronze', 'erp_px_cat_g1v2',   COUNT(*) FROM bronze.erp_px_cat_g1v2
UNION ALL SELECT 'silver', 'crm_cust_info',     COUNT(*) FROM silver.crm_cust_info
UNION ALL SELECT 'silver', 'crm_prd_info',      COUNT(*) FROM silver.crm_prd_info
UNION ALL SELECT 'silver', 'crm_sales_details', COUNT(*) FROM silver.crm_sales_details
UNION ALL SELECT 'silver', 'erp_cust_az12',     COUNT(*) FROM silver.erp_cust_az12
UNION ALL SELECT 'silver', 'erp_loc_a101',      COUNT(*) FROM silver.erp_loc_a101
UNION ALL SELECT 'silver', 'erp_px_cat_g1v2',   COUNT(*) FROM silver.erp_px_cat_g1v2
UNION ALL SELECT 'gold', 'dim_customers',       COUNT(*) FROM gold.dim_customers
UNION ALL SELECT 'gold', 'dim_products',        COUNT(*) FROM gold.dim_products
UNION ALL SELECT 'gold', 'fact_sales',          COUNT(*) FROM gold.fact_sales;

-- Q02: duplicados_en_claves
SELECT 'silver.crm_cust_info.cst_id' AS clave,
       COUNT(*) - COUNT(DISTINCT cst_id) AS duplicados,
       SUM(CASE WHEN cst_id IS NULL THEN 1 ELSE 0 END) AS nulos
FROM silver.crm_cust_info
UNION ALL
SELECT 'gold.dim_customers.customer_key', COUNT(*) - COUNT(DISTINCT customer_key),
       SUM(CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END)
FROM gold.dim_customers
UNION ALL
SELECT 'gold.dim_products.product_key', COUNT(*) - COUNT(DISTINCT product_key),
       SUM(CASE WHEN product_key IS NULL THEN 1 ELSE 0 END)
FROM gold.dim_products;

-- Q03: integridad_referencial_fact_sales
SELECT 'ventas sin cliente' AS revision, COUNT(*) AS filas
FROM gold.fact_sales f LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL
UNION ALL
SELECT 'ventas sin producto', COUNT(*)
FROM gold.fact_sales f LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
WHERE p.product_key IS NULL;

-- Q04: consistencia_ventas
SELECT 'ventas con sales_amount <> quantity * price' AS revision, COUNT(*) AS filas
FROM gold.fact_sales WHERE sales_amount <> quantity * price
UNION ALL
SELECT 'ventas con fecha de envio anterior a la de orden', COUNT(*)
FROM gold.fact_sales WHERE shipping_date < order_date
UNION ALL
SELECT 'ventas con valores nulos o negativos', COUNT(*)
FROM gold.fact_sales WHERE sales_amount IS NULL OR quantity IS NULL OR price IS NULL
   OR sales_amount < 0 OR quantity < 0 OR price < 0;

-- Q05: ventas_por_anio
SELECT YEAR(order_date) AS anio, COUNT(DISTINCT order_number) AS pedidos,
       SUM(quantity) AS unidades, SUM(sales_amount) AS ventas_totales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY anio;

-- Q06: ventas_por_categoria
SELECT p.category AS categoria, COUNT(DISTINCT f.order_number) AS pedidos,
       SUM(f.sales_amount) AS ventas_totales
FROM gold.fact_sales f JOIN gold.dim_products p ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY ventas_totales DESC;

-- Q07: ventas_por_pais
SELECT c.country AS pais, COUNT(DISTINCT f.customer_key) AS clientes,
       SUM(f.sales_amount) AS ventas_totales
FROM gold.fact_sales f JOIN gold.dim_customers c ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY ventas_totales DESC;

-- Q08: top_10_clientes
SELECT TOP 10 c.customer_key, c.first_name, c.last_name, c.country,
       SUM(f.sales_amount) AS ventas_totales
FROM gold.fact_sales f JOIN gold.dim_customers c ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name, c.country
ORDER BY ventas_totales DESC;
