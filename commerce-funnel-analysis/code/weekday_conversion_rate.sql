SELECT
  EXTRACT(DAYOFWEEK FROM event_time) AS dow,
  COUNT(DISTINCT CASE WHEN event_type='view' THEN user_id END) AS view_user,
  COUNT(DISTINCT CASE WHEN event_type='cart' THEN user_id END) AS cart_user,
  ROUND(COUNT(DISTINCT CASE WHEN event_type='cart' THEN user_id END) / COUNT(DISTINCT CASE WHEN event_type='view' THEN user_id END), 4) AS view_to_cart
FROM `event_log`
GROUP BY dow
ORDER BY view_to_cart DESC