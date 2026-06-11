--Find countries where the Top 5 customers contribute more than the Bottom 50% customers combined.

with cte1 as
(
select dc.country,
       fs.customer_key,
       sum(fs.sales_amount) as totalsales,
       dense_rank()over(partition by country order by sum(fs.sales_amount) desc) as rn,
       ntile(2)over(partition by country order by sum(fs.sales_amount) desc) as bot50
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country,fs.customer_key)
       ,cte2 as 
       (select country,
               sum(totalsales) as top5sales
               from cte1
               where rn<=5
               group by country)
               , cte3 as 
               (select country,
                       sum(totalsales) as bot50sales
                       from cte1
                       where bot50 = 2
                       group by country)

                       select * from cte2 as c2
                       left join cte3 as c3
                       on c2.country = c3.country
                       where top5sales > bot50sales

