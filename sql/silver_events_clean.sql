-- =========================================
-- SILVER LAYER: cleaned GA4 events (session-ready)
-- Purpose:
--   - Standardize/clean raw GA4 event data
--   - Extract ga_session_id from nested event_params
--   - Keep only fields needed for analytics
--   - Filter to rows with valid session IDs
-- =========================================

CREATE OR REPLACE VIEW `ab-predictive-portfolio.product_analytics_lab.stag_view` AS
SELECT
  -- Convert YYYYMMDD string to DATE type
  PARSE_DATE('%Y%m%d', event_date) AS event_dt,

  -- Keep original date string too (handy for debugging)
  event_date,

  -- Event timestamp in microseconds (raw GA4 format)
  event_timestamp,

  -- Core event fields
  event_name,
  user_pseudo_id,

  -- Extract session ID from nested event_params
  -- event_params is an array of key/value records
  (SELECT value.int_value
   FROM UNNEST(event_params)
   WHERE key = 'ga_session_id') AS ga_session_id,

  -- Session number can also be useful
  (SELECT value.int_value
   FROM UNNEST(event_params)
   WHERE key = 'ga_session_number') AS ga_session_number,

  -- Device / Geo / Traffic fields (dimensions for reporting)
  device.category AS device_category,
  device.operating_system AS device_os,
  geo.country AS country,
  geo.region AS region,
  geo.city AS city,
  traffic_source.source AS traffic_source,
  traffic_source.medium AS traffic_medium,
  traffic_source.name AS traffic_campaign

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201107'
  -- Keep only rows that can be assigned to a session
  AND (SELECT value.int_value
       FROM UNNEST(event_params)
       WHERE key = 'ga_session_id') IS NOT NULL;
