WITH temp_table AS (
  -- 이전 주문날짜, 첫 주문 날짜, 가입 날짜
  SELECT o.customer_id,
	booking_id,
         DATE_TRUNC(DATE(created_at), MONTH) AS order_month,
         LAG(DATE_TRUNC(DATE(created_at), MONTH)) 
         OVER (PARTITION BY o.customer_id ORDER BY created_at) AS prev_order_month,
         DATE_TRUNC(DATE(MIN(created_at) 
         OVER (PARTITION BY o.customer_id)), MONTH) AS first_order_month,
         DATE_TRUNC(DATE(c.first_join_date), MONTH) AS first_join_month
  FROM orders o
  LEFT JOIN customers c ON o.customer_id = c.customer_id
  WHERE EXTRACT(year FROM created_at) >= 2020
),

user_seg AS (
  SELECT order_month,
         customer_id,
	booking_id,
         CASE WHEN order_month = first_order_month THEN 'new_user'
              WHEN DATE_DIFF(order_month, prev_order_month, MONTH) < 2 THEN 'retained_user'
              ELSE 'resurrected_user'
         END AS seg,
         DATE_DIFF(order_month, first_join_month, YEAR) AS cohort   
  FROM order_table
  WHERE  EXTRACT(year FROM order_month) >= 2021  
)

SELECT month,
       cohort,
       COUNT(booking_id) AS order_count
FROM user_seg
WHERE seg = 'retained_user'
GROUP BY month, cohort
ORDER BY month, cohort
