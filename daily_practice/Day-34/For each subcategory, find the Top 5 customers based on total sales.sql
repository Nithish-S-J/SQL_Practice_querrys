----For each subcategory, find the Top 5 customers based on total sales.
--- Return subcategory, customer_name, total_sales, rank

with cte1 as 
(
select
     dc.customer_id,
     concat(dc.first_name, ' ',dc.last_name) as customer_name,
     dp.subcategory,
     sum(sales_amount) as total_sales,
     dense_rank()over(partition by subcategory order by sum(sales_amount) desc) as rn
     from gold.fact_sales as fs
     left join gold.dim_products as dp
     on fs.product_key = dp.product_key
     left join gold.dim_customers as dc
     on fs.customer_key = dc.customer_key
     group by customer_id, dp.subcategory, concat(dc.first_name, ' ',dc.last_name)
     )
     select * from cte1
     where rn<=5

