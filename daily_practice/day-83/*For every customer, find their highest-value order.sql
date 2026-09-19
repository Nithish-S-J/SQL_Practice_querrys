/*For every customer, find their highest-value order.

Return
customer_id
customer_name
country
order_number
order_date
order_revenue */

with cte1 as
(
select dc.customer_id,
       dc.first_name,
       dc.country,
       fs.order_number,
       fs.order_date,
       sum(sales_amount) as order_revenue,
       row_number()over(partition by dc.customer_id order by sum(sales_amount) desc) as rn
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.customer_id,
       dc.first_name,
       dc.country,
       fs.order_number,
       fs.order_date
       )
       select * from cte1
       where rn = 1
