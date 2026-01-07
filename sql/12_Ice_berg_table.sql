-- Iceberg Tables in Snowflake allow you to use the Apache Iceberg open table format while still leveraging Snowflake’s SQL engine, governance, and performance. In simple terms, Snowflake can query, manage, and govern Iceberg tables that live in external cloud storage (S3 / ADLS / GCS) without locking your data into Snowflake’s proprietary format.

CREATE OR REPLACE EXTERNAL VOLUME iceberg_s3_volume
STORAGE_LOCATIONS = (
  (
    NAME = 's3_loc'
    STORAGE_PROVIDER = 'S3'
    STORAGE_BASE_URL = ''
    STORAGE_AWS_ROLE_ARN = ''
    STORAGE_AWS_EXTERNAL_ID = ''

  )
);

describe  external volume iceberg_s3_volume;

SELECT SYSTEM$VERIFY_EXTERNAL_VOLUME('iceberg_s3_volume');




CREATE OR REPLACE ICEBERG TABLE sales_iceberg
  EXTERNAL_VOLUME = iceberg_s3_volume
  CATALOG = 'SNOWFLAKE'
AS
SELECT * FROM orders;



select * from sales_iceberg;
