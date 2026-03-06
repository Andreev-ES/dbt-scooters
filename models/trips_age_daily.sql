SELECT 
     ca.date
     ,ca.age 
     ,count(*) AS trips
     ,sum(price_rub) AS revenue_rub 
 FROM {{ ref("trips_users") }} AS ca
 GROUP BY ca.date
          ,ca.age 