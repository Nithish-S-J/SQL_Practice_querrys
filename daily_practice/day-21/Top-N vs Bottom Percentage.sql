---Find categories where the Top 5 products contribute more than the Bottom 50% of products combined.

with cte1 as
(
select dp.category, 
       fs.product_key,
       sum(fs.sales_amount) as totalsales,
       DENSE_RANK()over(partition by category order by sum(fs.sales_amount)desc) as rn,
       NTILE(2)over(partition by category order by sum(fs.sales_amount)asc) as botn
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category,fs.product_key
       )
       ,cte2 as 
       (select category,
               sum(totalsales) as top5sales
               from cte1
               where rn<=5
               group by category)
               , cte3 as 
               (select category,
                       sum(totalsales) as bot50sales
                       from cte1
                       where botn=1
                       group by category)

                       select * from cte2 as c2
                       join cte3 as c3
                       on c2.category = c3.category
                       where top5sales > bot50sales
