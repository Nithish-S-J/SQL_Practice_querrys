/*Find customers who placed at least 2 distinct orders.

Return
customer_id
customer_name
country
total_orders
total_revenue */
with cte1 as
(
select dc.customer_id,
       dc.first_name as customer_name,
       dc.country,
       count(distinct order_number) as total_orders,
       sum(sales_amount) as total_revenue
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.customer_id,
                dc.first_name,
                dc.country
                )
                select * from cte1
                where total_orders = 2
                
