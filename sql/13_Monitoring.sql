
-- Usage monitoring ensures cost control, performance optimization, and accountability across systems, users, and workloads.

-- which users are consuming most compute.

SELECT
    user_name,
    COUNT(*) AS total_queries,
    SUM(credits_used_cloud_services) AS credits_used
FROM snowflake.account_usage.query_history
GROUP BY user_name
ORDER BY credits_used DESC;


-- Which warehouse is under-utilized
SELECT
    warehouse_name,
    SUM(credits_used) AS total_credits,
    COUNT(*) AS total_queries
FROM snowflake.account_usage.warehouse_metering_history
GROUP BY warehouse_name;

-- Resize or suspend unused warehouses

-- Save cloud cost



-- Peak usage time analysis
SELECT
    HOUR(start_time) AS hour_of_day,
    COUNT(*) AS query_count
FROM snowflake.account_usage.query_history
GROUP BY hour_of_day
ORDER BY hour_of_day;



