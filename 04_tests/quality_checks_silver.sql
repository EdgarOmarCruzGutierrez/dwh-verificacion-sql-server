/*
===============================================================================
Verificaciones de calidad
===============================================================================
Propósito del script:
    Este script realiza diversas verificaciones de calidad sobre la consistencia, la exactitud
    y la estandarización de los datos de la capa 'silver'. Incluye verificaciones de:
    - Llaves primarias nulas o duplicadas.
    - Espacios no deseados en campos de texto.
    - Estandarización y consistencia de los datos.
    - Rangos y órdenes de fechas no válidos.
    - Consistencia de los datos entre campos relacionados.

Notas de uso:
    - Ejecuta estas verificaciones después de cargar la capa Silver.
    - Investiga y resuelve cualquier discrepancia encontrada en las verificaciones.
===============================================================================
*/

-- ====================================================================
-- Verificando 'silver.crm_cust_info'
-- ====================================================================
-- Verificar NULL o duplicados en la llave primaria
-- Resultado esperado: sin resultados
SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Verificar espacios no deseados
-- Resultado esperado: sin resultados
SELECT
    cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Estandarización y consistencia de los datos
SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info;

-- ====================================================================
-- Verificando 'silver.crm_prd_info'
-- ====================================================================
-- Verificar NULL o duplicados en la llave primaria
-- Resultado esperado: sin resultados
SELECT
    prd_id,
    COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Verificar espacios no deseados
-- Resultado esperado: sin resultados
SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Verificar NULL o valores negativos en el costo
-- Resultado esperado: sin resultados
SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Estandarización y consistencia de los datos
SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;

-- Verificar órdenes de fechas no válidos (fecha de inicio > fecha de fin)
-- Resultado esperado: sin resultados
SELECT
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Verificando 'silver.crm_sales_details'
-- ====================================================================
-- Verificar fechas no válidas
-- Nota: esta verificación lee bronze, porque silver ya guarda estas columnas como fechas reales
-- Resultado esperado: sin fechas no válidas
SELECT
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
    OR LEN(sls_due_dt) != 8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;

-- Verificar órdenes de fechas no válidos (fecha de pedido > fecha de envío/vencimiento)
-- Resultado esperado: sin resultados
SELECT
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Verificar la consistencia de los datos: Ventas = Cantidad * Precio
-- Resultado esperado: sin resultados
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Verificando 'silver.erp_cust_az12'
-- ====================================================================
-- Identificar fechas fuera de rango
-- Resultado esperado: fechas de nacimiento entre 1924-01-01 y hoy
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- Estandarización y consistencia de los datos
SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;

-- ====================================================================
-- Verificando 'silver.erp_loc_a101'
-- ====================================================================
-- Estandarización y consistencia de los datos
SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Verificando 'silver.erp_px_cat_g1v2'
-- ====================================================================
-- Verificar espacios no deseados
-- Resultado esperado: sin resultados
SELECT
    *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

-- Estandarización y consistencia de los datos
SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2;
