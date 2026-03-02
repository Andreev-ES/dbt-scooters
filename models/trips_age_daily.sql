WITH cte_age AS MATERIALIZED(
    SELECT 
        tr.started_at::date AS date
        ,(DATE_PART('year', tr.started_at) - DATE_PART('year', u.birth_date)) AS age
        ,price_rub 
    FROM {{ ref("trips_prep") }} AS tr 
            INNER JOIN {{ source("scooters_raw", "users") }} AS u 
                ON 1=1
                AND tr.user_id = u.id 
)
 SELECT 
      ca.date
      ,ca.age 
      ,count(*) AS trips
      ,sum(price_rub) AS revenue_rub 
  FROM cte_age AS ca
  GROUP BY ca.date
           ,ca.age 