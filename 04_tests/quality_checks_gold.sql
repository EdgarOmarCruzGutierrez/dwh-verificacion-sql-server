/*
===============================================================================
Verificaciones de calidad
===============================================================================
Propósito del script:
    Este script realiza verificaciones de calidad para validar la integridad, la consistencia
    y la exactitud de la capa Gold. Estas verificaciones aseguran:
    - Unicidad de las llaves sustitutas en las tablas de dimensión.
    - Integridad referencial entre las tablas de hechos y de dimensión.
    - Validación de las relaciones del modelo de datos con fines analíticos.

Notas de uso:
    - Investiga y resuelve cualquier discrepancia encontrada en las verificaciones.
===============================================================================
*/

-- ====================================================================
-- Verificando 'gold.dim_customers'
-- ====================================================================
-- Verificar la unicidad de la llave de cliente en gold.dim_customers
-- Resultado esperado: sin resultados
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Verificando 'gold.dim_products'
-- ====================================================================
-- Verificar la unicidad de la llave de producto en gold.dim_products
-- Resultado esperado: sin resultados
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Verificando 'gold.fact_sales'
-- ====================================================================
-- Verificar la conectividad del modelo de datos entre hechos y dimensiones
SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL
