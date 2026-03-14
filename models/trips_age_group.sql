SELECT 
   g."group" AS age_group
   ,count(*)
   ,sum(price_rub) AS revenue_rub 
FROM {{ ref("trips_users") }} AS u 
        LEFT JOIN {{ ref("age_groups") }} AS g 
            ON 1=1
            AND u.age BETWEEN g.age_start AND g.age_end  
GROUP BY g."group"