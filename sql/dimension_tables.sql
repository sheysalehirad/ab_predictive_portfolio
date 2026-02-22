-- =========================================
-- GOLD DIMENSIONS (small semantic layer)
-- =========================================
CREATE OR REPLACE TABLE `ab-predictive-portfolio.product_analytics_lab.gold_dim_date` AS
SELECT DISTINCT
  session_date AS date,
  EXTRACT(YEAR FROM session_date) AS year,
  EXTRACT(MONTH FROM session_date) AS month,
  EXTRACT(WEEK FROM session_date) AS week,
  EXTRACT(DAY FROM session_date) AS day
FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`;

CREATE OR REPLACE TABLE `ab-predictive-portfolio.product_analytics_lab.gold_dim_device` AS
SELECT DISTINCT
  device_category,
  device_os
FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`;

CREATE OR REPLACE TABLE `ab-predictive-portfolio.product_analytics_lab.gold_dim_geo` AS
SELECT DISTINCT
  country,
  region,
  city
FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`;

CREATE OR REPLACE TABLE `ab-predictive-portfolio.product_analytics_lab.gold_dim_traffic` AS
SELECT DISTINCT
  traffic_source,
  traffic_medium,
  traffic_campaign
FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`;
