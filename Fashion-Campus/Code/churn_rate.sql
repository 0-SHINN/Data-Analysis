WITH order_table AS (
  SELECT customer_id,
         DATE_TRUNC(DATE(created_at), MONTH) AS month
  FROM `fashion-campus-analysis.fashion_campus.transaction`
  WHERE payment_status = 'Success'AND EXTRACT(year FROM created_at) >= 2021
  GROUP BY customer_id, month
)

SELECT
  DATE(o1.month + INTERVAL 1 MONTH) AS churn_month, -- 이탈 기준 월
  COUNT(DISTINCT o1.customer_id) AS total_user_count, -- 기준 월에 구매한 유저 수
  COUNT(DISTINCT o1.customer_id) - COUNT(DISTINCT o2.customer_id) AS churn_user_count,  -- 다음 달에 구매하지 않은 유저 수(이탈 유저)
  ROUND((COUNT(DISTINCT o1.customer_id) - COUNT(DISTINCT o2.customer_id)) / COUNT(DISTINCT o1.customer_id), 2) AS churn_rate
FROM order_table o1
LEFT JOIN order_table o2 ON o1.customer_id = o2.customer_id
      AND o2.month = o1.month + INTERVAL 1 MONTH
WHERE DATE(o1.month + INTERVAL 1 MONTH) != '2022-08-01'
GROUP BY churn_month
ORDER BY churn_month