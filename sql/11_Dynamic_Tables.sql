-- What are Dynamic Tables in Snowflake?

-- Dynamic Tables in Snowflake are automatically refreshed tables that keep their data in sync with a query definition, similar to materialized views, but more flexible and powerful.

CREATE OR REPLACE DYNAMIC TABLE dt_daily_sales
TARGET_LAG = '1 minutes'
WAREHOUSE = compute_wh
AS
SELECT
  ORDER_DATE,
  SUM(AMOUNT) AS TOTAL_SALES
FROM ORDERS
GROUP BY ORDER_DATE;
SHOW DYNAMIC TABLES;

select * from dt_daily_sales;

describe table orders;

insert into orders VALUES 

(107,1000,'2024-03-01',1000,'DELIVERD'),
(108,1000,current_date(),1000,'PENDING'),
(109,2000,current_date(),1000,'PENDING'),
(110,1000,current_date(),1000,'PENDING'),
(110,1000,current_date(),1000,'PENDING');
;

SELECT * FROM dt_daily_sales;
--bronze
CREATE OR REPLACE DYNAMIC TABLE bronze_orders
TARGET_LAG = '1 minutes'
WAREHOUSE = compute_wh
AS
SELECT * FROM ORDERS;
--silver
CREATE OR REPLACE DYNAMIC TABLE silver_orders
TARGET_LAG = '1 minutes'
WAREHOUSE = compute_wh
AS
SELECT
  ORDER_ID,
  CUSTOMER_ID,
  ORDER_DATE,
  AMOUNT,
  STATUS
FROM bronze_orders
WHERE STATUS IN ('CONFIRMED', 'SHIPPED');
--gold
CREATE OR REPLACE DYNAMIC TABLE gold_sales_summary
TARGET_LAG = '5 minutes'
WAREHOUSE = compute_wh
AS
SELECT
  STATUS,
  COUNT(*) AS TOTAL_ORDERS,
  SUM(AMOUNT) AS TOTAL_AMOUNT
FROM silver_orders
GROUP BY STATUS;
DESCRIBE DYNAMIC TABLE gold_sales_summary;
ALTER DYNAMIC TABLE gold_sales_summary SUSPEND;
ALTER DYNAMIC TABLE gold_sales_summary RESUME;