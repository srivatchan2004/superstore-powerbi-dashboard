-- ============================================================
-- Query 02: Sales & Profit by Category and Segment
-- Database : superstore_db (MySQL)
-- Purpose  : Break down revenue and profitability across the
--            three product categories and three customer
--            segments — backing the two donut charts.
-- Columns  : category, segment, order_id, quantity, sales, profit
-- Output   : 9 rows (3 categories × 3 segments)
-- ============================================================

USE superstore_db;

SELECT
    category,
    segment,
    COUNT(DISTINCT order_id)                                      AS order_count,
    SUM(quantity)                                                  AS total_quantity,
    ROUND(SUM(sales), 2)                                          AS total_sales,
    ROUND(SUM(profit), 2)                                         AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2)          AS profit_margin_pct,
    ROUND(
        SUM(sales) * 100.0 /
        SUM(SUM(sales)) OVER (), 2
    )                                                              AS pct_of_total_sales
FROM superstore_sales
GROUP BY
    category,
    segment
ORDER BY
    category,
    total_sales DESC;
