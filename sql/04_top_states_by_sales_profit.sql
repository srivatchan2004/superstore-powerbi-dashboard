-- ============================================================
-- Query 04: Top 10 States by Sales and Profit
-- Database : superstore_db (MySQL)
-- Purpose  : Rank all states by total sales and return the
--            top 10 — backing the two horizontal bar charts.
--            ROW_NUMBER() window function is used for ranking.
-- Columns  : state, region, order_id, sales, profit
-- Output   : 10 rows ranked by sales DESC
-- ============================================================

USE superstore_db;

WITH state_metrics AS (
    SELECT
        state,
        region,
        COUNT(DISTINCT order_id)                               AS total_orders,
        ROUND(SUM(sales), 2)                                   AS total_sales,
        ROUND(SUM(profit), 2)                                  AS total_profit,
        ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2)   AS profit_margin_pct,
        ROW_NUMBER() OVER (ORDER BY SUM(sales) DESC)           AS sales_rank
    FROM superstore_sales
    GROUP BY state, region
)
SELECT
    sales_rank,
    state,
    region,
    total_orders,
    total_sales,
    total_profit,
    profit_margin_pct
FROM state_metrics
WHERE sales_rank <= 10
ORDER BY sales_rank;
