
/*
===========================================================================
Quality Checks
============================================================================
Script Purpose: 
	This script performs quality cehcks to validate the integrity, consistency, and accuracy of the Gold Layer.
	These checks ensure:
	- Uniqueness of surrogate keys in dimensions table.
	- Referential Integrity beteen fact and dimensions tables.
	- Validation of relationship in the data model for analytical purpose

Usage Notes:
	- Run these checks after data loading silver layer.
	-Investigate and resolve any discrepancies found during checks.

==============================================================================
*/

-- ==============================================================
-- Checking 'gold.dim_customers'
-- ==============================================================
-- check for uniqueness of customer key in gold.dim_customers
-- Expectation: No results

SELECT
	customer_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ===============================================================
-- Checking 'gold_product_key'
-- ===============================================================
-- Check for uniqueness of Product Key in gold.dim_products
-- Expectation: No results

SELECT
	product_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ===============================================================
-- Checking 'gold.fact_sales'
-- ===============================================================
-- -checks the data model connectivity between fact and dimensions

SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL


