-- 04_findings.sql
-- Queries that answer the project question: did wages keep up with prices?

-- Full result, one row per month.
SELECT * FROM wages_vs_inflation ORDER BY month;

-- How many months did wages fall behind prices?
SELECT
    COUNT(*) FILTER (WHERE real_wage_growth_pct < 0) AS months_behind,
    COUNT(*)                                         AS total_months
FROM wages_vs_inflation;

-- The five worst months for real wage growth.
SELECT month, wage_growth_pct, inflation_pct, real_wage_growth_pct
FROM wages_vs_inflation
ORDER BY real_wage_growth_pct
LIMIT 5;

-- The five months with the highest inflation.
SELECT month, inflation_pct, wage_growth_pct, real_wage_growth_pct
FROM wages_vs_inflation
ORDER BY inflation_pct DESC
LIMIT 5;

-- Average real wage growth by year.
SELECT
    EXTRACT(YEAR FROM month) AS year,
    ROUND(AVG(real_wage_growth_pct), 2) AS avg_real_wage_growth_pct
FROM wages_vs_inflation
GROUP BY 1
ORDER BY 1;
