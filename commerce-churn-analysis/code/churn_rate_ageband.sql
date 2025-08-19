WITH base AS (
  SELECT DISTINCT
    DATE_TRUNC(DATE(t.created_at), MONTH) AS month,
    t.customer_id,
    CASE WHEN DATE_DIFF(DATE '2022-06-01', c.birthdate, YEAR) <= 19 THEN '10대'
         WHEN DATE_DIFF(DATE '2022-06-01', c.birthdate, YEAR) <= 29 THEN '20대'
         WHEN DATE_DIFF(DATE '2022-06-01', c.birthdate, YEAR) <= 39 THEN '30대'
         ELSE '40대 이상'
    END AS age_band
  FROM `transaction` t
  JOIN `customers` c
    ON t.customer_id = c.customer_id
  WHERE t.payment_status = 'Success'
    AND DATE(t.created_at) BETWEEN '2022-06-01' AND '2022-07-31'
)

SELECT
  b1.age_band,
  COUNT(DISTINCT b1.customer_id) AS prev_users,
  COUNT(DISTINCT b2.customer_id) AS return_users,
  ROUND(1 - (COUNT(DISTINCT b2.customer_id) / COUNT(DISTINCT b1.customer_id)), 4) AS churn_rate
FROM base b1
LEFT JOIN base b2
       ON b1.customer_id = b2.customer_id
      AND b2.month = '2022-07-01'
WHERE b1.month = '2022-06-01'
GROUP BY age_band
ORDER BY age_band
