{% set date = var("date", none) %}
SELECT DISTINCT
    e.user_id
    ,e."timestamp"
    ,e.type_id
    ,{{ updated_at() }}
FROM {{ source("scooters_raw", "events") }} AS e
 WHERE
{% if is_incremental() %}
    {% if date %}
        date("timestamp") = date '{{ date }}'
    {% else %}
            "timestamp" > (
            SELECT max(e."timestamp") 
            FROM {{ this }} AS e
        )
    {% endif %}    
{% else %}
    e."timestamp" < '2023-08-01'::timestamp 
{% endif %}