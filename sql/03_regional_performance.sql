-- ============================================================
-- Query 03: Regional Performance
-- Database : superstore_db (MySQL)
-- Purpose  : Aggregate key metrics by Region — mirrors the
--            Central / East / South / West filter buttons and
--            adds avg delivery speed per region.
-- Columns  : region, order_id, quantity, sales, profit,
--            order_date, ship_date
-- Output   : 4 rows (one per region), sorted by sales DESC
-- ============================================================

USE superstore_db;

SELECT
    region,
    COUNT(DISTINCT order_id)                                        AS total_orders,
    SUM(quantity)                                                    AS total_quantity,
    ROUND(SUM(sales), 2)                                            AS total_sales,
    ROUND(SUM(profit), 2)                                           AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2)            AS profit_margin_pct,
    ROUND(
        SUM(sales) * 100.0 /
        SUM(SUM(sales)) OVER (), 2
    )                                                                AS pct_of_total_sales,
    -- NOTE: avg_delivery_days will show ~4 days per region (correct).
    -- Power BI shows "103" due to a date format misread (DD-MM-YYYY treated
    -- as MM-DD-YYYY during .pbix import). SQL value here is accurate.
    ROUND(AVG(DATEDIFF(ship_date, order_date)), 1)                  AS avg_delivery_days
FROM superstore_sales
GROUP BY region
ORDER BY total_sales DESC;
