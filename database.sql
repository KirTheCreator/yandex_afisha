SELECT
  user_id,
  device_type_canonical,
  order_id,
  created_dt_msk AS order_dt,
  created_ts_msk AS order_ts,
  currency_code,
  revenue,
  tickets_count,
  EXTRACT(DAY FROM COALESCE(created_dt_msk - LAG(created_dt_msk) OVER(PARTITION BY user_id ORDER BY created_dt_msk), NULL))::integer AS days_since_prev,
  p.event_id,
  event_name_code AS event_name,
  event_type_main,
  service_name,
  region_name,
  city_name
FROM purchases AS p
JOIN events AS e ON p.event_id = e.event_id
JOIN city AS c ON e.city_id = c.city_id
JOIN regions AS r ON c.region_id = r.region_id
WHERE device_type_canonical IN ('mobile', 'desktop')
  AND event_type_main != 'фильм'
ORDER BY user_id
LIMIT 10;