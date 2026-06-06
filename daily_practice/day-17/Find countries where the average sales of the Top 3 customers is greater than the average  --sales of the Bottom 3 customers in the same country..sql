--Find countries where the average sales of the Top 3 customers is greater than the average 
--sales of the Bottom 3 customers in the same country.

with cte1 as
(
select dc.country,
       fs.customer_key,
       avg(fs.sales_amount) as avgsales,
       dense_rank()over(partition by country order by avg(fs.sales_amount) desc) as top3,
       dense_rank()over(partition by country order by avg(fs.sales_amount) asc) as bot3
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country,fs.customer_key)
       , cte2 as 
       (select country,
               avg(avgsales) as avggsalesstop
               from cte1
               where top3 <=3
               group by country)
               , cte3 as 
               (select country,
                       avg(avgsales) as avggsalessbot
                       from cte1
                       where bot3 <=3
                       group by country)

                       select * from cte2 as c2
                       join cte3 as c3
                       on c2.country = c3.country
                      where avggsalesstop > avggsalessbot
