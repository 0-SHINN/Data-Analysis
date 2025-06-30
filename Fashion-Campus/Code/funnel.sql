WITH event_time_table AS (
  SELECT
    session_id,
    FORMAT_TIMESTAMP('%Y-%m', MIN(event_time)) AS session_month,
    MIN(CASE WHEN event_name = 'HOMEPAGE' THEN event_time END) AS homepage_time,
    MIN(CASE WHEN event_name = 'ITEM_DETAIL' THEN event_time END) AS detail_time,
    MIN(CASE WHEN event_name = 'ADD_TO_CART' THEN event_time END) AS cart_time,
    MIN(CASE WHEN event_name = 'BOOKING' THEN event_time END) AS booking_time
  FROM `click_stream`
  WHERE DATE(event_time) BETWEEN '2022-05-01' AND '2022-07-31'
  GROUP BY session_id
),
funnel_step AS (
  SELECT
    session_month,
    session_id,
    homepage_time,
    detail_time,
    cart_time,
    booking_time,
    CASE WHEN homepage_time IS NOT NULL THEN 1 ELSE 0 END AS step_home,
    CASE WHEN homepage_time IS NOT NULL AND detail_time IS NOT NULL AND homepage_time < detail_time THEN 1 ELSE 0 END AS step_detail,
    CASE WHEN homepage_time IS NOT NULL AND detail_time IS NOT NULL AND cart_time IS NOT NULL
              AND homepage_time < detail_time AND detail_time < cart_time THEN 1 ELSE 0 END AS step_cart,
    CASE WHEN homepage_time IS NOT NULL AND detail_time IS NOT NULL AND cart_time IS NOT NULL AND booking_time IS NOT NULL
              AND homepage_time < detail_time AND detail_time < cart_time AND TIMESTAMP_DIFF(booking_time,cart_time, DAY) <= 3 THEN 1 ELSE 0 END AS step_booking
  FROM event_time_table
)

SELECT
  session_month,
  COUNT(*) AS total_sessions,
  SUM(step_home) AS homepage_count,
  SUM(step_detail) AS detail_count,
  SUM(step_cart) AS cart_count,
  SUM(step_booking) AS booking_count,
  ROUND(SUM(step_detail) * 1.0 / NULLIF(SUM(step_home), 0), 4) AS to_detail_rate,
  ROUND(SUM(step_cart) * 1.0 / NULLIF(SUM(step_detail), 0), 4) AS to_cart_rate,
  ROUND(SUM(step_booking) * 1.0 / NULLIF(SUM(step_cart), 0), 4) AS to_booking_rate,
  ROUND(SUM(step_booking) * 1.0 / NULLIF(SUM(step_home), 0), 4) AS total_conversion_rate
FROM funnel_step
GROUP BY session_month
ORDER BY session_month