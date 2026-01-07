CREATE OR REPLACE stage JSONSTAGE
     url='s3://bucketsnowflake-jsondemo';

list @jsonstage;

CREATE OR REPLACE file format JSONFORMAT
    TYPE = JSON;
    
    
CREATE OR REPLACE table JSON_RAW (
    raw_file variant);
    
COPY INTO JSON_RAW
    FROM @JSONSTAGE
    file_format= JSONFORMAT
    files = ('HR_data.json');
    
   
SELECT * FROM  JSON_RAW;

SELECT 
    RAW_FILE:"id"::int Id,    
    RAW_FILE:"first_name"::string First_Name,
    RAW_FILE:"last_name"::string Lirst_Name,
    RAW_FILE:"city"::string City,
    RAW_FILE:"gender"::string Gener
FROM JSON_RAW;

SELECT 
    RAW_FILE:"id"::int Id,
    
    RAW_FILE:"first_name"::string First_Name,
    RAW_FILE:"last_name"::string Lirst_Name,
    RAW_FILE:"city"::string City,
    RAW_FILE:"gender"::string Gener,
    RAW_FILE:"job"."salary"::float Salary,
    RAW_FILE:"job"."title"::string Job_Title    
FROM JSON_RAW;

SELECT 
    RAW_FILE:"id"::int Id,
    RAW_FILE:"first_name"::string First_Name,
    RAW_FILE:"prev_company":: array prv_company
FROM JSON_RAW;

SELECT 
    RAW_FILE:"id"::int Id,
    RAW_FILE:"first_name"::string First_Name,
    array_size(RAW_FILE:"prev_company") companies
FROM JSON_RAW order by companies desc;

SELECT 
    RAW_FILE:"id"::int Id,
    RAW_FILE:"first_name"::string First_Name,
    RAW_FILE:"prev_company"[0]::string as first_company,
    RAW_FILE:"prev_company"[1]::string as second_company,
    RAW_FILE:"prev_company"[2]::string as third_company
FROM JSON_RAW;

CREATE TABLE HR_DATA AS
select RAW_FILE:"id"::int Id,
       RAW_FILE:"first_name"::string First_Name,
        RAW_FILE:"prev_company"[0]::string as first_company,
        RAW_FILE:"prev_company"[1]::string as second_company,
        RAW_FILE:"prev_company"[2]::string as third_company,
        t.value:: string Company
from 
JSON_RAW,table(flatten(RAW_FILE:"prev_company")) t;




create table hr_data_language
as

SELECT
    RAW_FILE:"id"::int Id,
    f.value:language::STRING AS language,
    f.value:level::STRING    AS level
FROM 
JSON_RAW,table(flatten(RAW_FILE:"spoken_languages")) f;

