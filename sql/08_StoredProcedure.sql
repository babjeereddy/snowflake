-- A Stored Procedure is a programmable database object that lets you execute multiple SQL statements with control flow, variables, and exception handling—all in one reusable unit.

-- Run multiple statements in sequence
-- Use IF / ELSE / LOOP
-- Read and modify tables (INSERT, UPDATE, DELETE)
-- Handle errors (EXCEPTION / TRY-CATCH)

CREATE OR REPLACE PROCEDURE hello_proc()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    RETURN 'Hello from Snowflake Stored Procedure';
END;
$$;

call hello_proc();



CREATE OR REPLACE PROCEDURE total_amount_by_status_sp(p_status STRING)
RETURNS NUMBER
LANGUAGE SQL
AS
$$
DECLARE
    total_amt NUMBER;
BEGIN
    SELECT SUM(AMOUNT)
    INTO :total_amt
    FROM ORDERS
    WHERE STATUS = :p_status;

    RETURN NVL(total_amt, 0);
END;
$$;

call total_amount_by_status_sp('PENDING');



CREATE OR REPLACE PROCEDURE get_total_amount_sp1(p_status STRING)
RETURNS NUMBER
LANGUAGE SQL
AS
$$
DECLARE
    v_total NUMBER;
BEGIN
   
    SELECT SUM(AMOUNTS)
    INTO :v_total
    FROM ORDERS
    WHERE STATUS = :p_status;



EXCEPTION
    WHEN STATEMENT_ERROR THEN
        RETURN -1;    
    WHEN OTHER THEN
        RETURN -2;    
END;
$$;

call get_total_amount_sp1('PENDING');



CREATE OR REPLACE PROCEDURE total_amount_py(p_status STRING)
RETURNS FLOAT
LANGUAGE PYTHON
RUNTIME_VERSION = 3.10
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'run'
AS
$$
def run(session, p_status):
    try:
        result = session.sql(f"""
            SELECT SUM(AMOUNT) FROM ORDERS
            WHERE STATUS = '{p_status}'
        """).collect()
        return result[0][0] or 0
    except Exception as e:
        return f"ERROR: {e}"
$$;

CALL TOTAL_AMOUNT_PY('PENDING');





