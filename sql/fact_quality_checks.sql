-- =========================================
-- QUALITY CHECKS FOR GOLD FACT TABLE
-- =========================================

-- 1) Row count
SELECT COUNT(*) AS total_sessions 
FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`;

-- 2) checking for duplicates, fact table  (should return 0 rows)
SELECT session_key, COUNT(*) AS c
FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`
GROUP BY session_key
HAVING c>1;

-- 3) Null key check (should be 0)
SELECT COUNT(*) AS null_session_keys
FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`
where session_key IS NULL;

-- 4) Funnel step counts (usually should decrease)
SELECT
  SUM(viewed_item) AS viewed_item_sessions,
  SUM(added_to_cart) AS add_to_cart_sessions,
  SUM(began_checkout) AS begin_checkout_sessions,
  SUM(added_shipping) AS added_shipping_sessions,
  SUM(added_payment) AS added_payment_sessions,
  SUM(purchased) AS purchase_sessions
FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`;

-- 5) Flag distribution checks (values should be 0 or 1)
SELECT viewed_item, COUNT(*) AS sessions
FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`
GROUP BY viewed_item
ORDER BY viewed_item;

SELECT added_to_cart, COUNT(*) AS sessions
FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`
GROUP BY added_to_cart
ORDER BY added_to_cart;

SELECT purchased, COUNT(*) AS sessions
FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`
GROUP BY purchased
ORDER BY purchased;

-- 6) Negative durations
SELECT COUNT(*) AS negative_duration_sessions
FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`
WHERE session_duration_seconds < 0;

-- 7) Users with multiple sessions (top users)
SELECT
  user_pseudo_id,
  COUNT(*) AS num_sessions
  FROM `ab-predictive-portfolio.product_analytics_lab.gold_fact_sessions`
  GROUP BY user_pseudo_id
  ORDER BY num_sessions DESC
  LIMIT 50;
