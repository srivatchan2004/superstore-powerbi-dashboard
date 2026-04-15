-- ============================================================
-- Query 05: Year-over-Year (YoY) Growth Rate
-- Database : superstore_db (MySQL)
-- Purpose  : Compare 2019 vs 2020 totals for sales, profit,
--            and quantity, then calculate growth % for each.
--            Backs the two YoY line charts.
-- Technique: CTE + conditional aggregation (CASE WHEN)
-- Columns  : order_date, sales, profit, quantity, order_id
-- Output   : One row — 2019 totals, 2020 totals, growth %
-- ============================================================

USE superstore_db;

WITH yearly_totals AS (
    SELECT
        -- 2019 metrics
        ROUND(SUM(CASE WHEN YEAR(order_date) = 2019 THEN sales    ELSE 0 END), 2) AS sales_2019,
        ROUND(SUM(CASE WHEN YEAR(order_date) = 2019 THEN profit   ELSE 0 END), 2) AS profit_2019,
        SUM(CASE WHEN YEAR(order_date) = 2019 THEN quantity ELSE 0 END)           AS qty_2019,

        -- 2020 metrics
        ROUND(SUM(CASE WHEN YEAR(order_date) = 2020 THEN sales    ELSE 0 END), 2) AS sales_2020,
        ROUND(SUM(CASE WHEN YEAR(order_date) = 2020 THEN profit   ELSE 0 END), 2) AS profit_2020,
        SUM(CASE WHEN YEAR(order_date) = 2020 THEN quantity ELSE 0 END)           AS qty_2020
    FROM superstore_sales
)
SELECT
    sales_2019,
    sales_2020,
    ROUND((sales_2020  - sales_2019)  / NULLIF(sales_2019,  0) * 100, 2) AS sales_growth_pct,

    profit_2019,
    profit_2020,
    ROUND((profit_2020 - profit_2019) / NULLIF(profit_2019, 0) * 100, 2) AS profit_growth_pct,

    qty_2019,
    qty_2020,
    ROUND((qty_2020    - qty_2019)    / NULLIF(qty_2019,    0) * 100, 2) AS qty_growth_pct
FROM yearly_totals;
