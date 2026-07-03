---Question Create monthly customer cohorts based on first purchase month.
---- Return, cohort_month, total_customers, retained_next_month, retention_rate_pct

with cte1 as
(
select fs.customer_key,
       DATEFROMPARTS(year(min(order_date)),month(min(order_date)),1) as cohort_month
       from gold.fact_sales as fs
       group by customer_key
       )
       , cte2 as
       (select distinct
               fs.customer_key,
                DATEFROMPARTS(year(order_date),month(order_date),1) as monthly_cohort
               from gold.fact_sales as fs
            
               )

               select
                      fp.cohort_month,
                      count(fp.customer_key) as total_customers,
                      count(mp.customer_key) as retained_customers,
                                            
                      round(100.0*count(mp.customer_key)/nullif(count(fp.customer_key),0),2) as retention_rate_pct

                     from cte1 as fp
                     left join cte2 as mp
                     on mp.customer_key = fp.customer_key
                     and  mp.monthly_cohort = dateadd(month, 1 , fp.cohort_month)
                     group by fp.cohort_month
                     order by fp.cohort_month
