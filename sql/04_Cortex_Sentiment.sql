-- CORTEX.SENTIMENT() is a Snowflake Cortex AI function that analyzes text sentiment and tells you whether the text is Positive, Negative, Neutral, or Mixed, along with a confidence score.

 -- `-1.0` → `-0.25` | Negative 
 -- `-0.25` → `0.25` | Neutral  
 -- `0.25` → `1.0`   | Positive 


SELECT SNOWFLAKE.CORTEX.SENTIMENT(
  'The service was excellent'
) AS sentiment;



SELECT
  SNOWFLAKE.CORTEX.SENTIMENT('The service was excellent') AS sentiment_score,
  CASE
    WHEN SNOWFLAKE.CORTEX.SENTIMENT('The service was excellent') > 0.25
      THEN 'POSITIVE'
    WHEN SNOWFLAKE.CORTEX.SENTIMENT('The service was excellent') < -0.25
      THEN 'NEGATIVE'
    ELSE 'NEUTRAL'
  END AS sentiment_label;


SELECT
  SNOWFLAKE.CORTEX.SENTIMENT('I am very happy with the product') AS s1,
  SNOWFLAKE.CORTEX.SENTIMENT('The delivery was delayed')        AS s2,
  SNOWFLAKE.CORTEX.SENTIMENT('The order has been processed')    AS s3;

CREATE OR REPLACE TABLE customer_feedback (
  id INT,
  feedback STRING
);

INSERT INTO customer_feedback VALUES
(1, 'The product quality is excellent'),
(2, 'Customer support was very slow'),
(3, 'Order delivered as expected');


SELECT
  id,
  comment,
  SNOWFLAKE.CORTEX.SENTIMENT(comment) AS sentiment
FROM feedback;

--Auto-Language Handling
SELECT SNOWFLAKE.CORTEX.SENTIMENT(
  'உங்கள் சேவை மிகவும் மோசமாக உள்ளது'
) AS sentiment;

--Translate → Sentiment (High Accuracy)

SELECT
  feedback,
  SNOWFLAKE.CORTEX.SENTIMENT(
    SNOWFLAKE.CORTEX.TRANSLATE(comment, NULL, 'en')
  ) AS sentiment
FROM feedback;
