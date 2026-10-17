USE DataWarehouse;
GO

-- 1. Conteo de filas por capa (bronze vs silver vs gold)
SELECT 'bronze' AS layer, 'crm_cust_info' AS tbl, COUNT(*) AS n FROM bronze.crm_cust_info
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
UNION ALL SELECT 'gold',   'dim_customers',     COUNT(*) FROM gold.dim_customers
UNION ALL SELECT 'gold',   'dim_products',      COUNT(*) FROM gold.dim_products
UNION ALL SELECT 'gold',   'fact_sales',        COUNT(*) FROM gold.fact_sales;
GO

-- 2. Ventas huérfanas (debe dar 0)
SELECT COUNT(*) AS ventas_sin_dimension
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products  p ON p.product_key  = f.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;
GO

-- 3. Ventas totales por año
SELECT YEAR(order_date) AS anio,
       COUNT(DISTINCT order_number) AS ordenes,
       SUM(sales_amount)            AS ventas
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY anio;
GO

-- 4. Top 10 países por ventas
SELECT TOP 10 c.country, SUM(f.sales_amount) AS ventas, COUNT(DISTINCT c.customer_key) AS clientes
FROM gold.fact_sales f
JOIN gold.dim_customers c ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY ventas DESC;
GO

-- 5. Top 10 productos
SELECT TOP 10 p.product_name, p.category, SUM(f.sales_amount) AS ventas, SUM(f.quantity) AS unidades
FROM gold.fact_sales f
JOIN gold.dim_products p ON p.product_key = f.product_key
GROUP BY p.product_name, p.category
ORDER BY ventas DESC;
GO

-- 6. Ventas por categoría con % del total
SELECT p.category,
       SUM(f.sales_amount) AS ventas,
       CAST(100.0 * SUM(f.sales_amount) / SUM(SUM(f.sales_amount)) OVER () AS DECIMAL(5,2)) AS pct
FROM gold.fact_sales f
JOIN gold.dim_products p ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY ventas DESC;
GO

-- 7. Ventas mensuales con acumulado y crecimiento vs mes anterior
WITH m AS (
    SELECT DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS mes,
           SUM(sales_amount) AS ventas
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
)
SELECT mes, ventas,
       SUM(ventas) OVER (ORDER BY mes) AS acumulado,
       CAST(100.0 * (ventas - LAG(ventas) OVER (ORDER BY mes)) / NULLIF(LAG(ventas) OVER (ORDER BY mes), 0) AS DECIMAL(8,2)) AS crec_pct
FROM m
ORDER BY mes;
GO

-- 8. Segmentación de clientes (VIP / Regular / New)
WITH s AS (
    SELECT customer_key, SUM(sales_amount) AS gasto,
           DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS meses_vida
    FROM gold.fact_sales GROUP BY customer_key
)
SELECT CASE WHEN meses_vida >= 12 AND gasto > 5000 THEN 'VIP'
            WHEN meses_vida >= 12 THEN 'Regular'
            ELSE 'New' END AS segmento,
       COUNT(*) AS clientes
FROM s GROUP BY CASE WHEN meses_vida >= 12 AND gasto > 5000 THEN 'VIP'
                     WHEN meses_vida >= 12 THEN 'Regular'
                     ELSE 'New' END
ORDER BY clientes DESC;
GO

-- 9. Consistencia de ventas: sales = quantity * price (debe dar 0)
SELECT COUNT(*) AS inconsistentes
FROM gold.fact_sales
WHERE sales_amount <> quantity * price OR sales_amount IS NULL OR price IS NULL OR quantity IS NULL;
GO

-- 10. Perfil de género y estado civil
SELECT gender, marital_status, COUNT(*) AS clientes
FROM gold.dim_customers
GROUP BY gender, marital_status
ORDER BY clientes DESC;
GO
