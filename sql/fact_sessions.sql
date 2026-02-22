-- =========================================
-- GOLD FACT TABLE + DIMENSIONS
-- Source: silver_events_clean
-- Grain: 1 row per (user_pseudo_id, ga_session_id)
-- =========================================
CREATE OR REPLACE TABLE `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions` AS
WITH session_base AS (
  SELECT
    user_pseudo_id,
    ga_session_id,

    -- Session date = earliest event date in the session
    MIN(event_dt) AS session_date,

    -- Stable session-level attributes (should be constant within a session)
    ANY_VALUE(device_category) AS device_category,
    ANY_VALUE(device_os) AS device_os,
    ANY_VALUE(country) AS country,
    ANY_VALUE(region) AS region,
    ANY_VALUE(city) AS city,
    ANY_VALUE(traffic_source) AS traffic_source,
    ANY_VALUE(traffic_medium) AS traffic_medium,
    ANY_VALUE(traffic_campaign) AS traffic_campaign,

    -- Funnel flags (0/1)
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS viewed_item,
    MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
    MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS began_checkout,
    MAX(CASE WHEN event_name = 'add_shipping_info' THEN 1 ELSE 0 END) AS added_shipping,
    MAX(CASE WHEN event_name = 'add_payment_info' THEN 1 ELSE 0 END) AS added_payment,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchased,

    -- Count of event rows in the session
    COUNT(*) AS num_events,

    -- Session timing
    MIN(event_timestamp) AS session_start_ts,
    MAX(event_timestamp) AS session_end_ts
  From `ab-predictive-portfolio.product_analytics_lab.stag_view` TABLE
  GROUP BY user_pseudo_id, ga_session_id
)
SELECT
  -- Unique session key for joins, dashboards, and QA
  CONCAT(CAST(user_pseudo_id AS STRING), '-', CAST(ga_session_id AS STRING)) AS session_key,

  user_pseudo_id,
  ga_session_id,
  session_date,

  -- Dimensions
  device_category,
  device_os,
  country,
  region,
  city,
  traffic_source,
  traffic_medium,
  traffic_campaign,

  -- Funnel flags
  viewed_item,
  added_to_cart,
  began_checkout,
  added_shipping,
  added_payment,
  purchased,

  -- Measures
  num_events,
  SAFE_DIVIDE((session_end_ts - session_start_ts), 1000000) AS session_duration_seconds

FROM session_base;



