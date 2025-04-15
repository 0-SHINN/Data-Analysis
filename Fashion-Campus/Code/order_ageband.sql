WITH temp_table AS (
 -- 유저 AGE 추가
  SELECT o.customer_id,
	    booking_id,
         EXTRACT(year FROM CURRENT_DATETIME()) - EXTRACT(year FROM birthdate) + 1 AS age,
         DATE_TRUNC(DATE(created_at), MONTH) AS order_month,
         LAG(DATE_TRUNC(DATE(created_at), MONTH)) 
OVER (PARTITION BY o.customer_id ORDER BY created_at) AS prev_order_month,
         DATE_TRUNC(DATE(MIN(created_at) 
OVER (PARTITION BY o.customer_id)), MONTH) AS first_order_month
  FROM orders o
  LEFT JOIN customers c ON o.customer_id = c.customer_id
  WHERE EXTRACT(year FROM created_at) >= 2021
),

user_seg AS (
  SELECT order_month,
         customer_id,
	booking_id,
         CASE WHEN age >= 10 AND age < 20 THEN '10대'
            WHEN age >= 20 AND age < 30 THEN '20대'
            WHEN age >= 30 AND age < 40 THEN '30대'
            WHEN age >= 40 AND age < 50 THEN '40대'
            ELSE '50-'
        END AS age_band,
         CASE WHEN order_month = first_order_month THEN 'new_user'
              WHEN DATE_DIFF(order_month, prev_order_month, MONTH) < 2 THEN 'retained_user'
              ELSE 'resurrected_user'
         END AS seg,
  FROM temp_table
)

SELECT order_month,
       age_band,
       COUNT(booking_id) AS order_count
FROM user_seg
WHERE seg = 'retained_user'
GROUP BY order_month, age_band
ORDER BY order_month, age_band