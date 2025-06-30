SELECT DATE_TRUNC(DATE(created_at), MONTH) AS month,
           CAST(SUM(item_price * quantity) *  0.08462 / COUNT(booking_id)AS INT64) AS AOV
FROM orders
WHERE EXTRACT(year FROM created_at) >= 2021
GROUP BY month
ORDER BY month