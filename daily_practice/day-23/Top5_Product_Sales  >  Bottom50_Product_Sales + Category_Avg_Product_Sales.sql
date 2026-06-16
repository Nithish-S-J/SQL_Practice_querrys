---Find categories where the Top 5 products contribute more sales than the combined sales of the 
---Bottom 50% products and the category average product sales together.

with productsales as
(
select dp.category,
       fs.product_key,
       sum(fs.sales_amount) as totalsales,
       DENSE_RANK()over(partition by category order by sum(fs.sales_amount)desc) as top5,
       PERCENT_RANK()over(partition by category order by sum(fs.sales_amount)asc) as bot50
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category,fs.product_key
       )
       ,cte1 as 
       (select category,
               sum(totalsales) as top5productsales
               from productsales
               where top5<=5
               group by category)
               , cte2 as 
               (select category,
                       sum(totalsales) as bot50sales
                       from productsales
                       where bot50<=0.50
                       group by category)
                       ,cte3 as 
                       (select category,
                               avg(totalsales) as avgcategorysales
                               from productsales               
                               group by category)

                               select *,
                                      round(100.0*top5productsales/bot50sales/avgcategorysales,2) as sales_multiple
                                      from cte1 as c1
                                      join cte2 as c2
                                      on c1.category = c2.category
                                      join cte3 as c3
                                      on c2.category = c3.category

                                      where top5productsales > bot50sales + avgcategorysales
