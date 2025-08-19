WITH first_order AS (
  SELECT
    customer_id,
    MIN(DATE(created_at)) AS first_order_date
  FROM `transaction`
  WHERE payment_status = 'Success'
  GROUP BY customer_id
),

cohort AS (
  SELECT
    DATE_DIFF(DATE(t.created_at), f.first_order_date, MONTH) AS diff_month,
    FORMAT_DATE('%Y-%m', f.first_order_date) AS cohort_month,
    COUNT(DISTINCT t.customer_id) AS user_cnt
  FROM `transaction` t
  JOIN first_order f ON t.customer_id = f.customer_id
  WHERE t.payment_status = 'Success'
    AND DATE(f.first_order_date) >= '2022-01-01'
  GROUP BY cohort_month, diff_month
)

SELECT
  cohort_month,
  diff_month,
  user_cnt,
  ROUND(user_cnt / FIRST_VALUE(user_cnt) 
       OVER (PARTITION BY cohort_month ORDER BY diff_month 
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 4) AS retention_rate
FROM cohort
ORDER BY cohort_month, diff_month