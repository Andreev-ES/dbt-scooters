WITH unnest_cte AS MATERIALIZED (
    -- Unnest trip to two rows: start and finish events
    SELECT 
        unnest(array[started_at, finished_at]) as "timestamp"
        ,unnest(array[1, -1]) as increment
    FROM {{ source('scooters_raw', 'trips') }}
)
,sum_cte AS MATERIALIZED (
    -- Make timestamp unique, group increments
    SELECT 
        "timestamp"
        ,sum(increment) as increment
        ,true as preserve_row
    FROM unnest_cte
    WHERE 1=1
    AND {% if is_incremental() %}
            "timestamp" > (select max("timestamp") from {{ this }})
        {% else %}
            "timestamp" < (('2023-06-01'::timestamp + '7 hour'::interval) at time zone 'Europe/Moscow')
        {% endif %}    
    GROUP BY "timestamp"
    {% if is_incremental() %}
    UNION ALL 
    SELECT
        "timestamp"
        ,concurrency as increment
        ,false as preserve_row
    FROM {{ this }}
    WHERE 1=1
    AND  "timestamp" = (select max("timestamp") from {{ this }})
    {% endif %}    
)
,cumsum_cte AS (
    -- Integrate increment to get concurrency
    SELECT 
        "timestamp"
        ,preserve_row
        ,sum(increment) over (order by "timestamp") as concurrency
    FROM sum_cte
)
SELECT 
    "timestamp"
    ,concurrency
    ,{{ updated_at() }}
FROM cumsum_cte
WHERE 1=1
AND preserve_row = true
ORDER BY "timestamp"