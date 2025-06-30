WITH event_time_table AS (
  SELECT
    session_id,
    MIN(CASE WHEN event_name = 'ITEM_DETAIL' THEN event_time END) AS detail_time,
    MIN(CASE WHEN event_name = 'ADD_TO_CART' THEN event_time END) AS cart_time
  FROM click_stream
  WHERE event_name IN ('ITEM_DETAIL', 'ADD_TO_CART')
    AND DATE(event_time) BETWEEN '2022-05-01' AND '2022-07-31'
  GROUP BY session_id
),
duration_time_table AS (
  SELECT
    session_id,
    TIMESTAMP_DIFF(cart_time, detail_time, SECOND) AS duration_sec,
    FORMAT_DATE('%Y-%m', detail_time) AS month,
    CASE
      WHEN TIMESTAMP_DIFF(cart_time, detail_time, SECOND) <= 5 THEN '0~5초'
      WHEN TIMESTAMP_DIFF(cart_time, detail_time, SECOND) <= 10 THEN '5~10초'
      WHEN TIMESTAMP_DIFF(cart_time, detail_time, SECOND) <= 20 THEN '10~20초'
      ELSE '20초 이상'
    END AS duration_time
  FROM event_time_table
  WHERE detail_time IS NOT NULL 
    AND cart_time IS NOT NULL 
    AND detail_time < cart_time
)

SELECT
  month,
  duration_time,
  COUNT(DISTINCT session_id) AS cart_sessions
FROM duration_time_table
GROUP BY month, duration_time