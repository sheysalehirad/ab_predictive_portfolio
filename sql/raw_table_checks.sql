-- 1) check num of events per user
SELECT
  event_name,
  user_pseudo_id,
  COUNT(*) AS n
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  GROUP BY 1,2
  ORDER BY n DESC;

-- 2) How to know if the same user ID had multiple sessions
-- Query (on raw GA4 events)
SELECT
  user_pseudo_id,
  COUNT(DISTINCT (SELECT value.int_value
  FROM UNNEST(event_params)
  WHERE key = 'ga_session_id')) AS num_sessions
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  -- WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201107'
  GROUP BY user_pseudo_id
  ORDER BY num_sessions DESC
  LIMIT 50;

-- 3) how to check “same ID had multiple sessions” distribution
SELECT
  num_sessions,
  COUNT(*) AS users
  FROM (
  SELECT
    user_pseudo_id,
    COUNT(*) AS num_sessions
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  GROUP BY user_pseudo_id
  )
  GROUP BY num_sessions
  ORDER BY num_sessions;

-- 4) How many event names there are
SELECT COUNT(DISTINCT event_name) AS num_event_types
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201107';

-- 5) list all event names and counts
SELECT
  event_name,
  COUNT(*) AS n
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  --WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201107'
  GROUP BY event_name
  ORDER BY n DESC;

-- 6) checking for duplicates, bronze table
SELECT
  COUNT(*) AS rows_total,
  COUNTIF((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') IS NULL) AS rows_missing_session
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201107';


