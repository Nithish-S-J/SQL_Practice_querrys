/* Find customers who have made at least one purchase overall but have never purchased any product from the Accessories category.

Return
customer_id
customer_name
country
total_revenue
total_orders */

select 

       dc.customer_id,
       dc.first_name,
       dc.country,
       sum(sales_amount) as total_revenue,
       count(*) as total_orders 
       from gold.fact_sales as fs
       inner join gold.dim_customers as dc
       on fs. customer_key = dc.customer_key
       inner join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by 
       dc.customer_id,
       dc.first_name,
       dc.country
       having sum(case when category = 'accessories' then 1 
                   else 0 
                   end) = 0
