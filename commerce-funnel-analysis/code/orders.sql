SELECT
  FORMAT_DATE('%Y-%m', DATE(t.created_at)) AS month,
  CASE
    WHEN DATE_TRUNC(DATE(t.created_at), MONTH) = DATE_TRUNC(DATE(c.first_join_date), MONTH) THEN '신규'
    ELSE '기존'
  END AS customer_group,
  COUNT(*) AS order_count
FROM
  customers` c
JOIN
  `transaction` t
ON
  t.customer_id = c.customer_id
WHERE
  t.payment_status = 'Success'
  AND
  t.created_at >= '2022-01-01'
GROUP BY
  month, customer_group
ORDER BY
  month, customer_group