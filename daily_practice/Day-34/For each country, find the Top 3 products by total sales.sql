---For each country, find the Top 3 products by total sales.
---Return: , country, product_name, total_sales, product_rank

with cte1 as
(
select dc.country,
       dp.product_key,
       dp.product_name,
       sum(fs.sales_amount) as total_sales,
       row_number()over(partition by country order by sum(fs.sales_amount) desc) as rn 
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by country, dp.product_key, dp.product_name
       )
       
               select country,
                      product_name,
                      total_sales,
                      rn as product_rank
                      from cte1
                      where rn <=3
