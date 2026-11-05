-- 03_create_view.sql
-- Cleans both raw tables, joins them by month, and calculates year-over-year
-- wage growth, inflation and real wage growth. Saved as a view so the result
-- can be queried (and loaded into Power BI) as one clean table.
--
-- Steps (one CTE per step):
--   wages_clean : keep one wage series, convert text to a real date and number
--   cpi_clean   : keep one CPI series (Canada, All-items), same conversions
--   combined    : join the two series on month (months missing from either drop out)
--   yoy         : LAG(x, 12) looks back 12 months, so each value is compared with
--                 the same month a year earlier
-- Real wage growth = wage growth minus inflation, in percentage points.

CREATE VIEW wages_vs_inflation AS
WITH wages_clean AS (
    SELECT
        TO_DATE(ref_date || '-01', 'YYYY-MM-DD')  AS month,
        NULLIF(TRIM(value), '')::NUMERIC          AS avg_weekly_earnings
    FROM raw_wages
    WHERE naics ILIKE 'Industrial aggregate%'
      AND employee_type ILIKE 'All employees%'
      AND overtime ILIKE 'Including overtime%'
),
cpi_clean AS (
    SELECT
        TO_DATE(ref_date || '-01', 'YYYY-MM-DD')  AS month,
        NULLIF(TRIM(value), '')::NUMERIC          AS cpi
    FROM raw_cpi
    WHERE geo = 'Canada'
      AND products = 'All-items'
),
combined AS (
    SELECT w.month, w.avg_weekly_earnings, c.cpi
    FROM wages_clean w
    JOIN cpi_clean c ON w.month = c.month
),
yoy AS (
    SELECT
        month,
        avg_weekly_earnings,
        cpi,
        ROUND((avg_weekly_earnings / LAG(avg_weekly_earnings, 12) OVER (ORDER BY month) - 1) * 100, 2) AS wage_growth_pct,
        ROUND((cpi / LAG(cpi, 12) OVER (ORDER BY month) - 1) * 100, 2) AS inflation_pct
    FROM combined
)
SELECT
    month,
    avg_weekly_earnings,
    cpi,
    wage_growth_pct,
    inflation_pct,
    ROUND(wage_growth_pct - inflation_pct, 2) AS real_wage_growth_pct
FROM yoy
WHERE wage_growth_pct IS NOT NULL;
