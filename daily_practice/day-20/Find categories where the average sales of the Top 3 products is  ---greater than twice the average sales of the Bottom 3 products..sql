--Find categories where the average sales of the Top 3 products is 
---greater than twice the average sales of the Bottom 3 products.
with cte1 as
(
select dp.category,
       fs.product_key,
       avg(fs.sales_amount) as avgsales,
       dense_rank()over(partition by dp.category order by avg(fs.sales_amount) desc) as topn,
       dense_rank()over(partition by dp.category order by avg(fs.sales_amount) asc) as botn
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category, fs.product_key)
       , cte2 as 
       (select category,
               avg(avgsales) as top3sales
               from cte1 
               where topn <=3
               group by category)
               , cte3 as
               (select category,
                       avg(avgsales) as bot3sales
                       from cte1 
                       where botn <=3
                       group by category)
                        
                       select * from cte2 as c2
                       join cte3 as c3
                       on c2.category = c3.category
                       where top3sales > 2*bot3sales
