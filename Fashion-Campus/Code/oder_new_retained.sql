WITH temp_table AS (
-- 이전 주문 날짜와 첫 주문 날짜
  SELECT customer_id,
	     booking_id,
             DATE_TRUNC(DATE(created_at), MONTH) AS order_month,
             LAG(DATE_TRUNC(DATE(created_at), MONTH)) 
	     OVER (PARTITION BY customer_id ORDER BY created_at) AS prev_order_month,
             DATE_TRUNC(DATE(MIN(created_at) 
	     OVER (PARTITION BY customer_id)), MONTH) AS first_order_month,
  FROM orders
  WHERE EXTRACT(year FROM created_at) >= 2021
),

user_seg AS (
  SELECT order_month,
       	     customer_id,
	     booking_id,
             CASE WHEN order_month = first_order_month THEN 'new_user' 		-- 주문월과 첫 주문월이 같다면 신규 유저
                  WHEN DATE_DIFF(order_month, prev_order_month, MONTH) < 2 THEN 'retained_user'	--이전 주문과 1개월 이하 차이면 기존 유저
                  ELSE 'resurrected_user'                                       -- 2개월 이상 차이나면 복귀 유저
              END AS seg
  FROM temp_table  
)

SELECT order_month,
       COUNT(CASE WHEN seg = 'new_user' THEN booking_id END) AS order_new_user,
       COUNT(CASE WHEN seg = 'retained_user' THEN booking_id END) AS order_retained_user,
       COUNT(CASE WHEN seg = 'resurrected_user' THEN booking_id END) AS order_resurrected_user
FROM user_seg
GROUP BY order_month
ORDER BY order_month
