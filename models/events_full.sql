SELECT
    *
FROM {{ ref('events_clean') }}
    LEFT JOIN {{ ref('event_types') }}
        USING (type_id)