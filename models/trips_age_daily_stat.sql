SELECT 
   cc.age 
   ,avg(cc.trips) AS avg_trips 
   ,avg(cc.revenue_rub) AS avg_revenue_rub
FROM {{ ref("trips_age_daily") }} AS cc
GROUP BY cc.age