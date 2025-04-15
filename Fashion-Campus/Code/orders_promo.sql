SELECT DATE_TRUNC(DATE(created_at), MONTH) AS month,
       COUNT(CASE WHEN promo_amount > 0 THEN booking_id END) AS with_promo,
       COUNT(CASE WHEN promo_amount = 0 THEN booking_id END) AS without_promo
FROM orders
WHERE EXTRACT(year FROM created_at) >= 2021
GROUP BY month
ORDER BY month