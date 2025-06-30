WITH event_time_table AS (
  SELECT
    session_id,
    MIN(CASE WHEN event_name = 'ITEM_DETAIL' THEN event_time END) AS detail_time,
    MIN(CASE WHEN event_name = 'ADD_TO_CART' THEN event_time END) AS cart_time,
    MIN(CASE WHEN event_name = 'ADD_PROMO' THEN event_time END) AS promo_time
  FROM click_stream
  WHERE event_name IN ('ITEM_DETAIL', 'ADD_TO_CART', 'ADD_PROMO')
    AND DATE(event_time) BETWEEN '2022-01-01' AND '2022-07-31'
  GROUP BY session_id
)

SELECT
  CASE
    WHEN promo_time IS NOT NULL AND cart_time < promo_time THEN 'with_promo'
    ELSE 'without_promo'
  END AS promo_group,
  COUNT(*) AS detail_sessions,
  SUM(CASE WHEN cart_time IS NOT NULL AND detail_time < cart_time THEN 1 ELSE 0 END) AS cart_sessions,
  ROUND(SUM(CASE WHEN cart_time IS NOT NULL AND detail_time < cart_time THEN 1 ELSE 0 END) * 1.0 / COUNT(*), 4) AS conversion_rate
FROM event_time_table
WHERE detail_time IS NOT NULL
GROUP BY promo_group
