 WITH first_join AS(
  -- 첫 주문 일자
  SELECT c.first_join_date,
         c.customer_id
  FROM customers c
  LEFT JOIN orders o ON c.customer_id = o.customer_id
  GROUP BY c.customer_id, first_join_date
  ORDER BY c.customer_id
 ),

 cohort AS(
  -- 가입 일자 별 코호트
  SELECT o.customer_id,
         first_join_date,
         DATE_DIFF(DATE(created_at), first_join_date, MONTH) AS month_diff,
         DATE_TRUNC(first_join_date, MONTH) AS first_join_month
  FROM orders o
  LEFT JOIN first_join f ON o.customer_id = f.customer_id
 )

-- 리텐션
SELECT first_join_month,
       month_diff,
       COUNT(DISTINCT customer_id) / FIRST_VALUE(COUNT(DISTINCT(customer_id)))
       OVER (PARTITION BY first_join_month ORDER BY month_diff 
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) * 100 AS retention
FROM cohort
GROUP BY first_join_month, month_diff
ORDER BY first_join_month, month_diff