--Find countries where the average sales of the
--Top 2 customers is greater than twice the average sales of the Bottom 2 customers in the same country.

with cte1 as
(
select dc.country,
       fs.customer_key,
       avg(fs.sales_amount) as avgsales,
       dense_rank()over(partition by country order by avg(fs.sales_amount) desc ) as top2,
       dense_rank()over(partition by country order by avg(fs.sales_amount) asc ) as bot2
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country, fs.customer_key
       )
       , cte2 as 
       (select country,
               avg(avgsales) as avggsalesstop
               from cte1
               where top2 <=2
               group by country)
               , cte3 as 
               (select country,
                       avg(avgsales) as avggsalessbot
                       from cte1
                       where bot2 <=2
                       group by country)
                       
                       select * from cte2 as c2
                       join cte3 as c3
                       on c2.country = c3.country
                       where avggsalesstop > 2*avggsalessbot
                       

