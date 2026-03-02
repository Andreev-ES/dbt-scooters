SELECT 
    tr.id
    ,tr.user_id
    ,tr.scooter_hw_id
    ,tr.started_at
    ,tr.finished_at
    ,tr.start_lat
    ,tr.start_lon
    ,tr.finish_lat
    ,tr.finish_lon
    ,tr.distance AS distance_m
    ,(tr.price/100.0)::decimal(20, 2) AS price_rub
    ,extract(epoch from (finished_at - started_at)) AS duration_s
    ,CASE 
        WHEN tr.price = 0 AND tr.distance > 0 THEN TRUE 
    ELSE 
        FALSE 
    END AS is_free 
    ,tr.started_at::date AS "date"
FROM {{ source("scooters_raw", "trips") }} AS tr