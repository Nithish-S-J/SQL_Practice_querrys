---Question  Create monthly customer cohorts based on first purchase month.
---- Return, cohort_month, total_customers, retained_next_month, retention_rate_pct

with first_purchase as 
(
select 
       fs.customer_key,
       DATEFROMPARTS(year(min(order_date)),month(min(order_date)),1) as cohort_month
       from gold.fact_sales as fs
       group by fs.customer_key
       )
       , monthly_purchase as
       (select distinct
               fs.customer_key,
               DATEFROMPARTS(year(order_date),month(order_date),1) as monthly_purchase
               from gold.fact_sales as fs
               
               )
                
                select fp.cohort_month,
                       count(fp.customer_key) as total_customers,
                       count(mp.customer_key) as retained_next_month,
                        
                       round(100.0*count(mp.customer_key)/count(fp.customer_key),2 ) as retention_pct

                       from first_purchase as fp
                       left join monthly_purchase as mp
                       on fp.customer_key = mp.customer_key
                       and mp.monthly_purchase = dateadd(month, 1, fp.cohort_month)

                       group by fp.cohort_month
                       order by fp.cohort_month
