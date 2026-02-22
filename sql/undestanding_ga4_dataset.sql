--Step 1 — Preview raw rows
SELECT event_date, event_name, user_pseudo_id
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
LIMIT 20;

--Step 2 — Test session ID extraction only
SELECT
  user_pseudo_id,
  event_name,
  (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS ga_session_id
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
LIMIT 20;

--Step 3 — Count rows after filtering valid sessions
SELECT COUNT(*) AS rows_with_session
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') IS NOT NULL;

--Step 4 — Build a tiny session aggregate (just one flag first)
SELECT
  user_pseudo_id,
  (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS ga_session_id,
  MAX(CASE WHEN event_name='purchase' THEN 1 ELSE 0 END) AS purchased
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201103'
GROUP BY user_pseudo_id, ga_session_id
LIMIT 100;

--Step 5 — Add more flags + dimensions
--Then expand to the full fact table.
--This layering helps you debug and understand every piece.
