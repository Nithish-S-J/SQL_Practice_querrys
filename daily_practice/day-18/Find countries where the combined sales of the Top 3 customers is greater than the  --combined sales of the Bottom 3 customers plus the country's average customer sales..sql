--Find countries where the combined sales of the Top 3 customers is greater than the 
--combined sales of the Bottom 3 customers plus the country's average customer sales.

with cte1 as
(
select dc.country,
       fs.customer_key,
       avg(fs.sales_amount) as avgsales,
       dense_rank()over(partition by dc.country order by avg(fs.sales_amount) desc) as top3,
       dense_rank()over(partition by dc.country order by avg(fs.sales_amount) asc) as bot3
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country, fs.customer_key)
       ,cte2 as 
       (select country,
               sum(avgsales) as combinedtop3
               from cte1
               where top3 <=3
               group by country)
               ,cte3 as 
               (select country,
                       sum(avgsales) as combinedbot3
                       from cte1
                       where bot3 <=3
                       group by country)
                       ,cte4 as 
                       (select country,
                               avg(avgsales) as avggsaless
                               from cte1
                               group by country)
                                
                               select * from cte2 as c2
                               join cte3 as c3
                               on c2.country = c3.country
                               join cte4 as c4
                               on c3.country = c4.country
                               where combinedtop3 > combinedbot3 + avggsaless

               


      
