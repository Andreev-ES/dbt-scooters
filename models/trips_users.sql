SELECT 
    t.*,
    u.sex,
    extract(year from t.started_at) - extract(year from u.birth_date) as age
FROM {{ ref("trips_prep") }} as t
        LEFT JOIN {{ source("scooters_raw", "users") }} as u
            ON 1=1
            AND t.user_id = u.id
{% if is_incremental() %}
    WHERE t.id > (
        SELECT max(id) 
        FROM {{ this }}
    )
    ORDER BY t.id
    LIMIT 75000
{% else %}
    WHERE t.id <= 75000
{% endif %}