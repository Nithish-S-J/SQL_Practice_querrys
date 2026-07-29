/* For every product category, find the Top 3 products by total revenue.

Include ties.

Return
category
product_key
product_name
total_revenue
revenue_rank */

with cte1 as
(
select 
       dp.category,
       dp.product_key,
       dp.product_name,
       sum(sales_amount) as total_revenue,
       rank()over(partition by category order by sum(sales_amount) desc) as revenue_rank
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by   dp.category,
                  dp.product_key,
                  dp.product_name
                  )
                  select * from cte1
                  where revenue_rank  <= 3
