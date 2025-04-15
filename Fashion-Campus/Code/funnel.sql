WITH purchase_user AS(
  SELECT DATE_TRUNC(DATE(event_time), MONTH) AS month,
         COUNT(CASE WHEN event_name = 'HOMEPAGE' THEN session_id END) AS homepage_count,
         COUNT(CASE WHEN event_name = 'ITEM_DETAIL' THEN session_id END) AS pageview_count,
         COUNT(CASE WHEN event_name = 'ADD_TO_CART' THEN session_id END) AS addtocart_count,
         COUNT(CASE WHEN event_name = 'BOOKING' THEN session_id END) AS purchase_count
  FROM user_log
  WHERE event_time BETWEEN '2021-01-01' AND '2022-07-31'
  GROUP BY month
  ORDER BY month
)

SELECT month,
       homepage_count,
       pageview_count,
       ROUND(pageview_count / homepage_count, 2) AS pageview_ratio,
       addtocart_count,
       ROUND(addtocart_count / pageview_count, 2) AS addtocart_ratio,
       purchase_count,
       ROUND(purchase_count / addtocart_count, 2) AS purchase_ratio,
FROM purchase_user
