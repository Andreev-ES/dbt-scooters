SELECT 
    count("type" = 'cancel_search' or null) / count("type" = 'start_search' or null)::float * 100. AS cancel_pct
FROM {{ ref("events_full") }} AS ef