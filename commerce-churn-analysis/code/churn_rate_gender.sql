WITH base AS (
  SELECT DISTINCT
    DATE_TRUNC(DATE(t.created_at), MONTH) AS month,
    t.customer_id,
    c.gender
  FROM `transaction` t
  JOIN `customers` c
    ON t.customer_id = c.customer_id
  WHERE t.payment_status = 'Success' 
    AND DATE(t.created_at) BETWEEN '2022-06-01' AND '2022-07-31'
)

SELECT
  b1.gender,
  COUNT(DISTINCT b1.customer_id) AS prev_users,
  COUNT(DISTINCT b2.customer_id) AS return_users,
  ROUND(1 - (COUNT(DISTINCT b2.customer_id) / COUNT(DISTINCT b1.customer_id)), 4) AS churn_rate
FROM base b1
LEFT JOIN base b2 
       ON b1.customer_id = b2.customer_id
      AND b2.month = '2022-07-01'
WHERE b1.month = '2022-06-01'
GROUP BY gender
ORDER BY gender