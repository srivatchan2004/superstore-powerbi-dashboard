-- ============================================================
-- Setup Script: Superstore Sales Database (MySQL)
-- ============================================================
-- Steps this script performs:
--   1. Creates database  : superstore_db
--   2. Creates table     : superstore_sales
--   3. Loads CSV data    : data/SuperStore_Sales_Dataset.csv
--
-- How to run:
--   Option A (MySQL Workbench)
--     Open this file → click the lightning bolt (Execute)
--
--   Option B (command line)
--     mysql -u root -p < sql/00_setup.sql
--
-- IMPORTANT: Update the file path in LOAD DATA LOCAL INFILE
--   below to match where you cloned/downloaded this repo.
-- ============================================================


-- ── 1. Create & select the database ────────────────────────
CREATE DATABASE IF NOT EXISTS superstore_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE superstore_db;


-- ── 2. Create the table ─────────────────────────────────────
DROP TABLE IF EXISTS superstore_sales;

CREATE TABLE superstore_sales (
    row_id        INT,
    order_id      VARCHAR(20),
    order_date    DATE,
    ship_date     DATE,
    ship_mode     VARCHAR(20),
    customer_id   VARCHAR(15),
    customer_name VARCHAR(100),
    segment       VARCHAR(20),
    country       VARCHAR(50),
    city          VARCHAR(100),
    state         VARCHAR(50),
    region        VARCHAR(20),
    product_id    VARCHAR(20),
    category      VARCHAR(30),
    sub_category  VARCHAR(30),
    product_name  VARCHAR(255),
    sales         DECIMAL(10, 4),
    quantity      INT,
    profit        DECIMAL(10, 4),
    returns       VARCHAR(10),
    payment_mode  VARCHAR(20),
    ind1          VARCHAR(10),
    ind2          VARCHAR(10)
);


-- ── 3. Load CSV data ─────────────────────────────────────────
-- UPDATE the path below to your local repo location.
-- Use forward slashes even on Windows.
-- Example: 'C:/Users/YourName/Downloads/superstore-powerbi-dashboard/data/SuperStore_Sales_Dataset.csv'

LOAD DATA LOCAL INFILE 'C:/Users/sriva/Downloads/DATAANALYST/linkedin/superstore/superstore-powerbi-dashboard/data/SuperStore_Sales_Dataset.csv'
INTO TABLE superstore_sales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS          -- skip the header row
(
    row_id,
    order_id,
    @order_date_raw,
    @ship_date_raw,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    profit,
    returns,
    payment_mode,
    ind1,
    ind2
)
SET
    -- CSV dates are DD-MM-YYYY → convert to MySQL DATE (YYYY-MM-DD)
    order_date = STR_TO_DATE(@order_date_raw, '%d-%m-%Y'),
    ship_date  = STR_TO_DATE(@ship_date_raw,  '%d-%m-%Y');


-- ── 4. Quick sanity check ────────────────────────────────────
SELECT
    COUNT(*)                    AS total_rows,
    MIN(order_date)             AS earliest_order,
    MAX(order_date)             AS latest_order,
    ROUND(SUM(sales), 2)        AS total_sales,
    ROUND(SUM(profit), 2)       AS total_profit
FROM superstore_sales;
-- Expected: ~5901 rows, 2019-01-01 to 2020-12-29
