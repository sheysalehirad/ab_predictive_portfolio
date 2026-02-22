# Data Dictionary

## Project: GA4 E-commerce Funnel Analytics (BigQuery)

## Medallion Layers
- **Bronze (source):** `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` (public GA4 event export)
- **Silver (cleaned):** `product_analytics_lab.silver_events_clean`
- **Gold (curated):** `product_analytics_lab.gold_fact_sessions` + dimensions

---

## Gold Fact Table

### `gold_fact_sessions`
**Grain:** 1 row per `(user_pseudo_id, ga_session_id)` session

### Key Columns
- `session_key` (STRING): concatenated unique key = `user_pseudo_id` + `ga_session_id`
- `user_pseudo_id`: pseudonymous user identifier from GA4
- `ga_session_id`: GA4 session identifier extracted from `event_params`
- `session_date` (DATE): earliest event date in the session

### Dimensions
- `device_category`: device type (desktop/mobile/tablet)
- `device_os`: device operating system
- `country`, `region`, `city`: geo dimensions
- `traffic_source`, `traffic_medium`, `traffic_campaign`: traffic acquisition dimensions

### Funnel Flags (0/1)
- `viewed_item`: session contained `view_item`
- `added_to_cart`: session contained `add_to_cart`
- `began_checkout`: session contained `begin_checkout`
- `added_shipping`: session contained `add_shipping_info`
- `added_payment`: session contained `add_payment_info`
- `purchased`: session contained `purchase`

### Measures
- `num_events`: number of event rows in the session
- `session_duration_seconds`: session duration in seconds

---

## Silver Table/View

### `silver_events_clean`
**Grain:** 1 row per event

Purpose:
- Standardize raw GA4 event data
- Extract nested session parameters
- Keep reporting-relevant dimensions
- Filter out rows without a valid session id

---

## Dimension Tables

### `gold_dim_date`
Date dimension for BI slicing and trend analysis.

### `gold_dim_device`
Distinct device categories and operating systems.

### `gold_dim_geo`
Distinct geographic values used in reporting.

### `gold_dim_traffic`
Distinct traffic acquisition values used in reporting.