WITH base AS (
  SELECT
    customer_id,
    DATE(created_at) AS order_date,
    DATE(LEAD(created_at) OVER (PARTITION BY customer_id ORDER BY created_at)) AS next_order_date,
    DATE_DIFF(DATE(LEAD(created_at) OVER (PARTITION BY customer_id ORDER BY created_at)), DATE(created_at), DAY) AS reorder_day,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY created_at, booking_id) AS rn
  FROM `transaction`
  WHERE payment_status = 'Success'
),

user_flag AS (
  SELECT
    customer_id,
    DATE_TRUNC(order_date, MONTH) AS first_month,
    order_date AS first_date,
    CASE WHEN reorder_day BETWEEN 1 AND 14 THEN 'TRUE' ELSE 'FALSE' END AS reorder_before_14d
  FROM base
  WHERE rn = 1
    AND order_date <= DATE '2022-06-16'
),

order_month AS (
  SELECT
    customer_id,
    MAX(CASE WHEN DATE_TRUNC(DATE(created_at), MONTH) = DATE '2022-06-01' THEN 1 ELSE 0 END) AS has_june,
    MAX(CASE WHEN DATE_TRUNC(DATE(created_at), MONTH) = DATE '2022-07-01' THEN 1 ELSE 0 END) AS has_july
  FROM `transaction`
  WHERE payment_status = 'Success'
  GROUP BY customer_id
)

SELECT
  u.reorder_before_14d,
  SUM(CASE WHEN o.has_june = 1 THEN 1 ELSE 0 END) AS n_prev, 
  SUM(CASE WHEN o.has_june = 1 AND o.has_july = 1 THEN 1 ELSE 0 END) AS n_return, 
  ROUND(1 - (SUM(CASE WHEN o.has_june = 1 AND o.has_july = 1 THEN 1 ELSE 0 END) / SUM(CASE WHEN o.has_june = 1 THEN 1 ELSE 0 END)), 4) AS churn_6to7
FROM user_flag u
JOIN order_month o
  ON u.customer_id = o.customer_id
GROUP BY u.reorder_before_14d
ORDER BY u.reorder_before_14d DESC