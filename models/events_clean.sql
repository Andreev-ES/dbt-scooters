SELECT DISTINCT
    e.user_id
    ,e."timestamp"
    ,e.type_id
    ,{{ updated_at() }}
FROM {{ source("scooters_raw", "events") }} AS e
{% if is_incremental() %}
    WHERE "timestamp" > (
        SELECT max(e."timestamp") 
        FROM {{ this }} AS e
    )
{% else %}
    WHERE e."timestamp" < '2023-08-01'::timestamp 
{% endif %}