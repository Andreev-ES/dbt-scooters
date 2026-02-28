SELECT
    started_at::date AS "date"
    ,count(*) AS trips 
    ,max(price) /100 AS max_price_rub 
    ,avg(distance) /1000 AS avg_distance_km 
FROM scooters_raw.trips
GROUP BY started_at::date