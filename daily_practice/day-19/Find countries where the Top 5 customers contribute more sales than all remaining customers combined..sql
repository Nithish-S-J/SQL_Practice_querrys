--Find countries where the Top 5 customers contribute more sales than all remaining customers combined.

with cte1 as
(
select dc.country,
       fs.customer_key,
       sum(fs.sales_amount) as totalsales,
       DENSE_RANK()over(partition by dc.country order by sum(fs.sales_amount) desc) as rn
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country,fs.customer_key
       )
       , cte2 as
       (select country,
               sum(totalsales) as top5sales
               from cte1 
               where rn <=5
               group by country)
               , cte3 as 
               (select country,
                       sum(totalsales) as countrysales
                       from cte1
                       group by country)
                       select * from cte2 as c2
                       join cte3 as c3
                       on c2.country = c3.country
                       where top5sales > countrysales - top5sales
