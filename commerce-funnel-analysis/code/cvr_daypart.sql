WITH event_time_table AS (
  SELECT
    session_id,
    MIN(CASE WHEN event_name = 'ITEM_DETAIL' THEN event_time END) AS detail_time,
    MIN(CASE WHEN event_name = 'ADD_TO_CART' THEN event_time END) AS cart_time
  FROM click_stream
  WHERE event_name IN ('ITEM_DETAIL', 'ADD_TO_CART')
    AND DATE(event_time) BETWEEN '2022-01-01' AND '2022-07-31'
  GROUP BY session_id
)

SELECT
  CASE
    WHEN EXTRACT(HOUR FROM detail_time) BETWEEN 0 AND 5 THEN '새벽'
    WHEN EXTRACT(HOUR FROM detail_time) BETWEEN 6 AND 11 THEN '오전'
    WHEN EXTRACT(HOUR FROM detail_time) BETWEEN 12 AND 17 THEN '오후'
    WHEN EXTRACT(HOUR FROM detail_time) BETWEEN 18 AND 23 THEN '야간'
    ELSE '기타'
  END AS day_part,
  COUNT(*) AS detail_sessions,
  SUM(CASE WHEN cart_time IS NOT NULL AND detail_time < cart_time THEN 1 ELSE 0 END) AS cart_sessions,
  ROUND(SUM(CASE WHEN cart_time IS NOT NULL AND detail_time < cart_time THEN 1 ELSE 0 END) * 1.0 / COUNT(*), 4) AS conversion_rate
FROM event_time_table
WHERE detail_time IS NOT NULL
GROUP BY day_part