WITH base AS (
  SELECT customer_id,
         COUNT(DISTINCT booking_id) AS order_cnt,
         MIN(DATE_TRUNC(DATE(created_at), MONTH)) AS first_month,
         CASE WHEN COUNT(DISTINCT booking_id) <= 2 THEN '1-2'
              WHEN COUNT(DISTINCT booking_id) <= 5 THEN '3-5'
              WHEN COUNT(DISTINCT booking_id) <= 19 THEN '6-19'
              WHEN COUNT(DISTINCT booking_id) <= 41 THEN '20-41'
              ELSE '42+' END AS order_group
  FROM `transaction`
  WHERE payment_status = 'Success'
  GROUP BY customer_id
),

monthly_active AS (
  SELECT
    b.order_group,
    DATE_DIFF(DATE_TRUNC(DATE(t.created_at), MONTH), b.first_month, MONTH) AS diff_month,
    COUNT(DISTINCT b.customer_id) AS user_cnt
  FROM base b
  JOIN `transaction` t
    ON b.customer_id = t.customer_id
   AND t.payment_status = 'Success'
  GROUP BY b.order_group, diff_month
)

SELECT
  order_group,
  diff_month,
  user_cnt,
  ROUND(user_cnt / FIRST_VALUE(user_cnt)
       OVER (PARTITION BY order_group ORDER BY diff_month 
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 4) AS retention_rate
FROM monthly_active
WHERE diff_month BETWEEN 0 AND 12
ORDER BY order_group, diff_month