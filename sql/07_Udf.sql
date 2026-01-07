-- A Snowflake UDF (User-Defined Function) is a custom function that you create in Snowflake to reuse your own business logic inside SQL queries—just like built-in functions

use snowpark_db.public;

CREATE OR REPLACE FUNCTION get_discount(amount NUMBER)
RETURNS NUMBER
AS
$$
    amount * 0.10
$$;

CREATE OR REPLACE FUNCTION get_discount1(amount NUMBER , discount float)
RETURNS float
AS
$$
    amount * discount
$$;
select get_discount1(10000,0.2);

show functions like 'GET_DISCOUNT';

select get_discount(10000);

select order_id,amount ,get_discount(amount) as discount from orders;

--udf with case statement

CREATE OR REPLACE FUNCTION calc_discount(amount NUMBER)
RETURNS NUMBER
AS
$$
    CASE
        WHEN amount < 1000 THEN amount * 0.05
        WHEN amount <= 5000 THEN amount * 0.10
        ELSE amount * 0.15
    END
$$;

select calc_discount(10000)+2000 test;

select order_id,amount,calc_discount(amount) as discount from orders;

-- A Table Function is a user-defined function that returns a TABLE (multiple rows and columns) instead of a single value.

CREATE OR REPLACE FUNCTION total_amount_by_status(p_status STRING)
RETURNS TABLE (TOTAL_AMOUNT NUMBER)
AS
$$
    SELECT SUM(AMOUNT) AS TOTAL_AMOUNT
    FROM ORDERS
    WHERE STATUS = p_status
$$;

SELECT * FROM 
TABLE(total_amount_by_status('PENDING'));


CREATE OR REPLACE FUNCTION order_summary_by_status(p_status STRING)
RETURNS TABLE (
    STATUS STRING,TOTAL_ORDERS NUMBER,    TOTAL_AMOUNT NUMBER
)
AS
$$
    SELECT
        STATUS,
        COUNT(*) AS TOTAL_ORDERS,
        SUM(AMOUNT) AS TOTAL_AMOUNT
    FROM ORDERS
    WHERE STATUS = p_status     GROUP BY STATUS
$$;

SELECT * FROM 
   TABLE(ORDER_SUMMARY_BY_STATUS('PENDING'));

-- PYTOHN  UDF 

CREATE OR REPLACE FUNCTION discount_py(amount FLOAT)
RETURNS FLOAT
LANGUAGE PYTHON
RUNTIME_VERSION = 3.10
HANDLER = 'calc_discount'
AS
$$
def calc_discount(amount):
    if amount is None:
        return 0.0
    return amount * 0.10
$$;

SELECT DISCOUNT_PY(10000) DISCOUNT;

SELECT ORDER_ID, AMOUNT,  DISCOUNT_PY(AMOUNT) DISCOUNT 
FROM ORDERS;



------------------------------------------------------
CREATE OR REPLACE FUNCTION discount_slab_py(amount FLOAT)
RETURNS FLOAT
LANGUAGE PYTHON
RUNTIME_VERSION = 3.10
HANDLER = 'slab_discount'
AS
$$
def slab_discount(amount):

    if amount is None:
        return 0.0

    if amount < 1000:
        return amount * 0.05
    elif amount <= 5000:
        return amount * 0.10
    else:
        return amount * 0.15
$$;

SELECT ORDER_ID,
     AMOUNT,
     DISCOUNT_SLAB_PY(AMOUNT) AS DISCOUNT
FROM ORDERS;


CREATE OR REPLACE FUNCTION upper_name_py(name STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = 3.10
HANDLER = 'upper_name'
AS
$$
def upper_name(name):
    if name is None:
        return None
    return name.upper()
$$;

SELECT UPPER_NAME_PY('ram') name;

SELECT CUSTOMER_ID,
      CUSTOMER_NAME,
      UPPER_NAME_PY(CUSTOMER_NAME) CUSTOMER_NAME_UPPER
      FROM CUSTOMERS;
      

CREATE OR REPLACE FUNCTION change_case_py(p_name varchar)
RETURNS varchar
LANGUAGE PYTHON
RUNTIME_VERSION = 3.10
HANDLER = 'to_upper'
AS
$$
def to_upper(p_name):

    if p_name is None:
        return ' '

    return p_name.upper()
$$;

select change_case_py('raheem')



     

