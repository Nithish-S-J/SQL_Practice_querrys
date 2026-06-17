---Return the Top 2 products by total sales.
--- category , product_name , total_sales, product_rank

with cte1 as 
(
select dp.category,
       dp.product_name,
       fs.product_key,
       sum(fs.sales_amount) as total_sales,
       ROW_NUMBER()over(partition by dp.category order by sum(fs.sales_amount)desc) as product_rank
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category,dp.product_name,fs.product_key
       )

       select 
               category,
               product_name,
               total_sales,
               product_rank
               from cte1
               where product_rank <=2
