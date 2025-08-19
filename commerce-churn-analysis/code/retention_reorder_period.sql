WITH base AS (
  SELECT customer_id,
         DATE(created_at) AS order_date,
         DATE(LEAD(created_at) OVER (PARTITION BY customer_id ORDER BY created_at)) AS next_order_date,
         DATE_DIFF(DATE(LEAD(created_at) OVER (PARTITION BY customer_id ORDER BY created_at)), DATE(created_at), DAY) AS reorder_day,
         ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY created_at) AS rn
  FROM `transaction`
  WHERE payment_status = 'Success'
),

user_flag AS (
  SELECT customer_id,
         DATE_TRUNC(order_date, MONTH) AS first_month,
         CASE WHEN reorder_day BETWEEN 1 AND 14 THEN 'TRUE' ELSE 'FALSE' END AS reorder_before_14d
  FROM base
  WHERE rn = 1 AND order_date <= '2022-07-01'
),

monthly_active AS (
  SELECT
    u.reorder_before_14d,
    DATE_DIFF(DATE_TRUNC(DATE(o.created_at), MONTH), u.first_month, MONTH) AS diff_month,
    COUNT(DISTINCT u.customer_id) AS user_cnt
  FROM user_flag u
  JOIN `transaction` o
    ON o.customer_id = u.customer_id
   AND o.payment_status = 'Success'
  GROUP BY u.reorder_before_14d, diff_month
)

SELECT
  reorder_before_14d,
  diff_month,
  user_cnt,
  ROUND(user_cnt / FIRST_VALUE(user_cnt)
       OVER (PARTITION BY reorder_before_14d ORDER BY diff_month 
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 4) AS retention_rate
FROM monthly_active
WHERE diff_month BETWEEN 0 AND 12
ORDER BY reorder_before_14d, diff_month