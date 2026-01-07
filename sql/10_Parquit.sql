CREATE OR REPLACE STAGE PARQUETSTAGE
    url = 's3://snowflakeparquetdemo'  ;

CREATE OR REPLACE FILE FORMAT PARQUET_FORMAT
    TYPE = 'parquet';

list @PARQUETSTAGE;
  
SELECT * 
FROM @PARQUETSTAGE
(file_format => 'PARQUET_FORMAT');
SELECT $1:id::string id,
       $1:cat_id::string cat_id,
       $1:dept_id::string dept_id,
       to_timestamp($1:date)::datetime order_date,
       $1:"item_id"::string,
       $1:state_id::string,
       $1:store_id::string,
       $1:value::int
from @parquetstage
(file_format => 'PARQUET_FORMAT');

