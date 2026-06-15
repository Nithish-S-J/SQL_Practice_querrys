--Find categories where the Top Quartile (Top 25%) products 
---contribute more sales than the Bottom 75% products combined.

with cte1 as
(
select dp.category,
       fs.product_key,
       sum(fs.sales_amount) as totalsales,
       percent_rank()over(partition by dp.category order by sum(fs.sales_amount)desc) as pctop25
       from gold.fact_sales as fs
       join gold.dim_products as dp
       on fs.product_key=dp.product_key
       group by dp.category,fs.product_key
       )
       , cte2 as 
       (select category,
               sum(totalsales) as pctop25
               from cte1
               where pctop25 <= 0.25
               group by category)
               , cte3 as 
               (select category,
                       sum(totalsales) as categorysales
                       from cte1
                       group by category)

                       select *
                              from cte2 as c2
                              join cte3 as c3
                              on c2.category = c3.category
                              where pctop25>categorysales-pctop25

