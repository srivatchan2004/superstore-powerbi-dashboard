-- ============================================================
-- Query 01: KPI Summary
-- Database : superstore_db (MySQL)
-- Purpose  : Reproduce the headline KPI cards shown on the
--            dashboard in a single query.
-- Columns  : sales, profit, quantity, order_id, order_date,
--            ship_date, customer_id, city
-- Output   : One row with all high-level metrics
-- ============================================================

USE superstore_db;

SELECT
    ROUND(SUM(sales), 2)                                          AS total_sales,
    ROUND(SUM(profit), 2)                                         AS total_profit,
    SUM(quantity)                                                  AS total_quantity,
    COUNT(DISTINCT order_id)                                       AS total_orders,
    COUNT(DISTINCT customer_id)                                    AS total_customers,
    COUNT(DISTINCT city)                                           AS total_cities,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2)          AS profit_margin_pct,
    -- NOTE: avg_delivery_days will show ~4 days (correct based on raw CSV data).
    -- The Power BI dashboard displays "103" days because Power BI misread the
    -- DD-MM-YYYY date format during import, inflating the calculated differences.
    -- The SQL result here is the accurate value.
    ROUND(AVG(DATEDIFF(ship_date, order_date)), 1)                AS avg_delivery_days
FROM superstore_sales;
