WITH base AS (
  SELECT customer_id,
         COUNT(DISTINCT booking_id) AS order_cnt,
         CASE WHEN COUNT(DISTINCT booking_id) <= 2 THEN '1-2'
              WHEN COUNT(DISTINCT booking_id) <= 5 THEN '3-5'
              WHEN COUNT(DISTINCT booking_id) <= 19 THEN '6-19'
              WHEN COUNT(DISTINCT booking_id) <= 41 THEN '20-41'
              ELSE '42+' END AS order_group
  FROM `transaction`
  WHERE payment_status = 'Success' 
    AND DATE(created_at) <= '2022-06-30'
  GROUP BY customer_id
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
  b.order_group,
  SUM(CASE WHEN o.has_june = 1 THEN 1 ELSE 0 END) AS n_prev,
  SUM(CASE WHEN o.has_june = 1 AND o.has_july = 1 THEN 1 ELSE 0 END) AS n_return,
  ROUND(1 - SAFE_DIVIDE(SUM(CASE WHEN o.has_june = 1 AND o.has_july = 1 THEN 1 ELSE 0 END), SUM(CASE WHEN o.has_june = 1 THEN 1 ELSE 0 END)), 4) AS churn_6to7
FROM base b
JOIN order_month o 
  ON b.customer_id = o.customer_id
GROUP BY b.order_group
ORDER BY b.order_group DESC