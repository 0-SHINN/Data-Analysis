WITH base AS (
  SELECT
    user_id,
    event_type,
    SPLIT(category_code, '.')[SAFE_OFFSET(0)] AS main_category,
    CASE WHEN price < 150 THEN 'LOW'
         WHEN price < 500 THEN 'MID'
         ELSE 'HIGH'
         END AS price_band
  FROM `event_log`
),

user_cnt AS (
  SELECT
    main_category,
    price_band,
    COUNT(DISTINCT CASE WHEN event_type='view' THEN user_id END) AS view_user,
    COUNT(DISTINCT CASE WHEN event_type='cart' THEN user_id END) AS cart_user
  FROM base
  GROUP BY main_category, price_band
)

SELECT
  main_category,
  price_band,
  view_user,
  cart_user,
  ROUND(cart_user / view_user,4) AS view_to_cart
FROM user_cnt
WHERE main_category IS NOT NULL
  AND view_user >= 50000
ORDER BY view_to_cart DESC