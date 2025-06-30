WITH cart_purchase_time AS (
  SELECT
    c.session_id,
    MIN(c.event_time) AS cart_time,
    MIN(t.created_at) AS purchase_time
  FROM click_stream c
  JOIN transaction t
    ON c.session_id = t.session_id
  WHERE c.event_name = 'ADD_TO_CART'
    AND t.payment_status = 'Success'
  GROUP BY c.session_id
)

SELECT
  CASE
    WHEN TIMESTAMP_DIFF(purchase_time, cart_time, HOUR) <= 24 THEN '24시간 이내'
    WHEN TIMESTAMP_DIFF(purchase_time, cart_time, HOUR) <= 72 THEN '3일 이내'
    WHEN TIMESTAMP_DIFF(purchase_time, cart_time, HOUR) <= 168 THEN '7일 이내'
    ELSE '7일 초과'
  END AS seg,
  COUNT(*) AS purchase,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS percentage
FROM cart_purchase_time
WHERE purchase_time >= cart_time
GROUP BY seg
ORDER BY seg