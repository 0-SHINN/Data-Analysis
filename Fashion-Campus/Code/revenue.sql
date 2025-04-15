SELECT DATE_TRUNC(DATE(created_at), MONTH) AS month,
       	   CAST(SUM(item_price * quantity) * 0.08462 AS INT64) AS revenue
FROM orders
WHERE EXTRACT(year FROM created_at) >= 2021
GROUP BY month
ORDER BY month