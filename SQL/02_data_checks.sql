-- 02_data_checks.sql
-- Sanity checks to run after importing the CSVs. An import can finish without
-- errors and still put data in the wrong place, so verify before building on it.

-- Row counts should match the number of data rows in each CSV (excluding the header).
SELECT COUNT(*) AS cpi_rows FROM raw_cpi;
SELECT COUNT(*) AS wage_rows FROM raw_wages;

-- Preview the first rows: dates should look like 2018-01 and values like numbers.
SELECT * FROM raw_cpi   LIMIT 10;
SELECT * FROM raw_wages LIMIT 10;

-- Which product categories are in the CPI file, and how many months does each have?
SELECT products, COUNT(*) AS months
FROM raw_cpi
GROUP BY products
ORDER BY products;

-- Which industry / employee type / overtime combinations are in the wage file?
SELECT naics, employee_type, overtime, COUNT(*) AS months
FROM raw_wages
GROUP BY naics, employee_type, overtime
ORDER BY naics;

-- Date range of each table.
SELECT MIN(ref_date) AS first_month, MAX(ref_date) AS last_month FROM raw_cpi;
SELECT MIN(ref_date) AS first_month, MAX(ref_date) AS last_month FROM raw_wages;
