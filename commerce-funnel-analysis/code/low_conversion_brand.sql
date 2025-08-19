WITH brand_stats AS (
  SELECT
    brand,
    SPLIT(category_code, '.')[SAFE_OFFSET(0)] AS main_category,
    COUNT(DISTINCT CASE WHEN event_type='view' THEN user_id END) AS view_user,
    COUNT(DISTINCT CASE WHEN event_type='cart' THEN user_id END) AS cart_user
  FROM `event_log`
  GROUP BY brand, main_category
),

low_conv_brand AS (
  SELECT
    brand,
    main_category
  FROM brand_stats
  WHERE view_user >= 1000
    AND cart_user / view_user < 0.1
  ORDER BY cart_user / view_user
  LIMIT 20
)

SELECT
  e.brand,
  l.main_category,
  CASE
    WHEN e.price < 150 THEN 'LOW'
    WHEN e.price < 500 THEN 'MID'
    ELSE 'HIGH'
  END AS price_band,
  COUNT(DISTINCT CASE WHEN e.event_type='view' THEN e.user_id END) AS view_user,
  COUNT(DISTINCT CASE WHEN e.event_type='cart' THEN e.user_id END) AS cart_user,
  ROUND(COUNT(DISTINCT CASE WHEN e.event_type='cart' THEN e.user_id END) / COUNT(DISTINCT CASE WHEN e.event_type='view' THEN e.user_id END), 4) AS view_to_cart
FROM `event_log` e
JOIN low_conv_brand l
  ON e.brand = l.brand
WHERE l.main_category IS NOT NULL
GROUP BY e.brand, l.main_category, price_band
ORDER BY e.brand, view_to_cart DESC