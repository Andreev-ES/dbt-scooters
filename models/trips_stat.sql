SELECT
    count(*) AS trips 
    ,count(DISTINCT user_id) AS users
    ,avg(duration_s) / 60 as avg_duration_m
    ,sum(price_rub) AS revenue_rub 
    ,count(is_free = TRUE or null) / cast(count(*) as real) * 100 AS free_trips_pct
    ,sum(distance_m) / 1000. AS sum_distance_km
FROM {{ ref("trips_prep") }}