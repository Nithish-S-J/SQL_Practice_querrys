--Find categories where the Top 10% products 
---contribute more sales than the Bottom 90% products combined.

with cte1 as
(
select dp.category,
       fs.product_key,
       sum(fs.sales_amount) as totalsales,
       PERCENT_RANK()over(partition by category order by sum(fs.sales_amount)desc) as topn      
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category, fs.product_key
       )
       , cte2 as 
       (select category,
               sum(totalsales) as top10sales
               from cte1 
               where topn<=0.10
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
                       where top10sales > categorysales - top10sales
