ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'AWS_US';

-- CORTEX.COMPLETE() is a Snowflake Cortex Generative AI function that lets you send a prompt to a large language model (LLM) directly from SQL and get back a text completion—similar to how ChatGPT responds to a question.

--SQL explanation Explain complex SQL to users
SELECT
  SNOWFLAKE.CORTEX.COMPLETE(
    'snowflake-arctic',
    'Explain what a primary key is in simple terms.'
  ) AS explanation;

--Data summarization Summarize reports, logs, comments
SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'snowflake-arctic',
  'Summarize monthly sales trend in simple business language'
) AS summary;

--summarizing table data

SELECT
  SNOWFLAKE.CORTEX.COMPLETE(
    'snowflake-arctic',
    'Summarize these sales numbers: Total Sales = 12M, Growth = 18%, Top Region = South'
  ) AS sales_summary;

-- rewriting
SELECT
  SNOWFLAKE.CORTEX.COMPLETE(
    'snowflake-arctic',
    'Rewrite the following sentence in a polite and professional tone:
     The site visit raised many unnecessary questions and caused confusion.'
  ) AS rewritten_text;

--Formalization (rewrite)
SELECT
  SNOWFLAKE.CORTEX.COMPLETE(
    'snowflake-arctic',
    'Rewrite this sentence in a formal and professional tone suitable for official email:
     Please finish this work fast and update me.'
  ) AS formal_text;

  -- Simplification (rewrite)

  SELECT
  SNOWFLAKE.CORTEX.COMPLETE(
    'snowflake-arctic',
    'Simplify the following sentence so that a non-technical person can understand it:
     The discrepancies observed during the audit require immediate rectification.'
  ) AS simple_text;

  --tone change(rewrite)
  SELECT
  SNOWFLAKE.CORTEX.COMPLETE(
    'snowflake-arctic',
    'Rewrite the sentence in a neutral and constructive tone:
     You failed to submit the report on time.'
  ) AS polite_version;

  --Batch rewriting from a table 
  create schema snowpark_db.cortext;

  CREATE OR REPLACE TABLE feedback (
  id INT,
  raw_text STRING
);

INSERT INTO feedback VALUES
(1, 'The builder is delaying work unnecessarily'),
(2, 'Too many irrelevant questions were raised in the meeting'),
(3, 'Finish this immediately');


SELECT
  id,
  raw_text,
  SNOWFLAKE.CORTEX.COMPLETE(
    'snowflake-arctic',
    'Rewrite the following text in a polite and professional tone:' || raw_text
  ) AS rewritten_text
FROM feedback;

-- business ready prompt temlet

SELECT
  SNOWFLAKE.CORTEX.COMPLETE(
    'snowflake-arctic',
    'Act as a senior corporate communication expert.
     Rewrite the text below to be:
     - Professional
     - Neutral
     - Suitable for audit or board-level communication

     Text:
     The contractor is careless and not cooperating.'
  ) AS board_ready_text;





