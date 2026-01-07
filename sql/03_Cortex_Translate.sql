--english to hindi
SELECT
  SNOWFLAKE.CORTEX.TRANSLATE(
    'Welcome to Snowflake Cortex',
    'en',
    'fr'
  ) AS translated_text;

SELECT
  SNOWFLAKE.CORTEX.TRANSLATE(
    
    'स्नोफ्लेक कॉर्टेक्स में आपका स्वागत है'
    ,
    'hi',
    'en'
  ) AS translated_text;




SELECT SNOWFLAKE.CORTEX.TRANSLATE(
  'Monthly sales report is ready',
  'en',
  'ta'
) as translated_text;


CREATE OR REPLACE TABLE feedback (
  id INT,
  comment STRING
);

INSERT INTO feedback VALUES
(1, 'The service was excellent'),
(2, 'Delivery was delayed'),
(3, 'Customer support is helpful');



SELECT
  id,
  comment,
  SNOWFLAKE.CORTEX.TRANSLATE(comment, 'en', 'fr') AS comment_french,
  SNOWFLAKE.CORTEX.TRANSLATE(comment, 'en', 'hi') AS comment_hindi,
  SNOWFLAKE.CORTEX.TRANSLATE(comment, 'en', 'mar') AS comment_marati,
  
  
FROM feedback;

SELECT
  id,
  comment,
  SNOWFLAKE.CORTEX.TRANSLATE(comment, 'en', 'HI') AS comment_french
FROM feedback;



--Auto Language Detection (Advanced)

SELECT SNOWFLAKE.CORTEX.TRANSLATE(
  'La qualité du produit est excellente',
  NULL,
  'en'
) AS TEXT;

--Multi-Language Reporting

SELECT SNOWFLAKE.CORTEX.TRANSLATE( COMMENT,'en', 'hi') Hindi,
       SNOWFLAKE.CORTEX.TRANSLATE( COMMENT,'en', 'ta') Tamil,
       SNOWFLAKE.CORTEX.TRANSLATE( COMMENT,'en', 'fr') french
from feedback;

