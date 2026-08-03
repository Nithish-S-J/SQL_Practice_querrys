/* Create customer cohorts based on each customer's first purchase month.

For every cohort calculate:

Total customers in the cohort
Customers who purchased again in the next calendar month
Customers who purchased again in the second calendar month after acquisition
Month-1 retention %
Month-2 retention %
Return
cohort_month
cohort_customers
retained_month_1
retained_month_2
month_1_retention_pct
month_2_retention_pct */

with cte1 as
(
select      
      customer_key,
      DATEFROMPARTS(year(min(order_date)),month(min(order_date)),1) as cohort_month
      from gold.fact_sales 
      group by customer_key
      )
      , cte2 as
      (select distinct
               customer_key,
              DATEFROMPARTS(year(order_date),month(order_date),1) as activity_month
              from gold.fact_sales 
              
              )
              ,cte3 as 
              (select   c1.customer_key,
                        c1.cohort_month,
                        c2.activity_month,
                       datediff(month, cohort_month, activity_month) as month_number
                      from cte1  as c1
                      join cte2 as c2
                      on c1.customer_key = c2.customer_key
                   
                      )

                   , cte4 AS
(
    SELECT
        cohort_month,

        COUNT(DISTINCT customer_key) AS cohort_customers,

        COUNT(DISTINCT CASE
            WHEN month_number = 1
            THEN customer_key
        END) AS retained_month_1,

        COUNT(DISTINCT CASE
            WHEN month_number = 2
            THEN customer_key
        END) AS retained_month_2

    FROM cte3
    GROUP BY cohort_month
)

SELECT
    cohort_month,
    cohort_customers,
    retained_month_1,
    retained_month_2,

    ROUND(
        100.0 * retained_month_1 /
        NULLIF(cohort_customers, 0),
        2
    ) AS month_1_retention_pct,

    ROUND(
        100.0 * retained_month_2 /
        NULLIF(cohort_customers, 0),
        2
    ) AS month_2_retention_pct

FROM cte4
ORDER BY cohort_month;
