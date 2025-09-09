/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
	This script performs various quality checks for data consistency, accuracy,
	and standardization across the 'silver' schemas. It includes checks for:
	- null or duplicate primary key.
	- Unwanted spaces in string fields.
	- Data standardization and consistency.
	- Invalid date ranges and orders.
	- Data consistency between related fields.

Usage Notes:
	- Run these checks after data loading silver layer.
	- Investigate and resolve any discrepancies found during the checks.
==================================================================================
*/

-- ===============================================================================
-- Check 'silver.crm_cust_info'
-- ================================================================================
-- Check for Nulls or Duplicates in the primary key
-- Expectation: No Result

-- For Customer Table
SELECT 
	cst_id, 
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted Spaces
-- Expectation: No Results
SELECT 
	cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data Standardization & Consistency
SELECT DISTINCT
	cst_martital_status
FROM silver.crm_cust_info;

-- ====================================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================================
-- Checks for NULLS or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
	prd_id, 
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL


-- Check for unwanted Spaces
-- Expectation: No Results

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for Nulls or Negative values in Cost
-- Expectation: No Results

SELECT DISTINCT 
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Standardization &  Consistency
SELECT DISTINCT 
	prd_line
FROM silver.crm_prd_info

-- Check for Invalid Date Orders (start Date > End Date)
-- Expectation: No Results
SELECT 
	*
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- ========================================================================================
-- Checking: 'silver.crm_sales_details'
-- ========================================================================================
-- Check for Invalid Dates
-- Expectation: No Invalid Dates

SELECT
	NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <=0
	 OR LEN(sls_due_dt) !=0
	 OR sls_due_dt > 20500101
	 OR sls_due_dt < 19000101;

-- Check for Invalid Date Orders (Order Date > Shipping/Due Dates)
-- Expectation: No Results
SELECT 
	* 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Check Data Consistency: Sales = Quantity * Price
-- Expectation: No Results
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

-- =================================================================================================
-- Checking 'silver.erp_cust_az12'
-- ==================================================================================================

-- Identify out of Range Dates
-- Expectation: No Results
SELECT DISTINCT 
	bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
	  OR bdate > GETDATE();

-- Data Standardization & Consistency
-- For unique values
SELECT DISTINCT 
	gen
FROM silver.erp_cust_az12

-- =============================================================================================
-- Checking 'silver.erp_loc_a101'
-- =============================================================================================
-- Data Standardization & Consistency

SELECT DISTINCT
	cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


-- Checking for Unmatched data for cleaning the '-' in between the letters
SELECT cid
FROM bronze.erp_loc_a101
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info)


-- Data Standardization & Consistency cleaning
SELECT DISTINCT 
cntry,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	 WHEN TRIM(cntry) IN ('US', 'USA', 'United states') THEN 'United States'
     WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	 ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101

-- =================================================================================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- =================================================================================================================================
-- Check for Unwanted Spaces
-- Expectation: No Results
--Check for Unwanted spaces in the category table
SELECT 
	*
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency in the silver category table
SELECT DISTINCT 
	maintenance
FROM silver.erp_px_cat_g1v2
