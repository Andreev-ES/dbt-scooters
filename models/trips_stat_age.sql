WITH cte_age AS MATERIALIZED(
    SELECT 
        tr.started_at::date AS date
        ,(DATE_PART('year', tr.started_at) - DATE_PART('year', u.birth_date)) AS age
    FROM scooters_raw.trips AS tr 
            INNER JOIN scooters_raw.users AS u 
                ON 1=1
                AND tr.user_id = u.id 
)
,cte_count AS MATERIALIZED(
    SELECT 
        ca.date
        ,ca.age 
        ,count(*) AS trips
    FROM cte_age AS ca
    GROUP BY ca.date
             ,ca.age     
)
SELECT 
   cc.age 
   ,avg(cc.trips) AS avg_trips 
FROM cte_count AS cc
GROUP BY cc.age