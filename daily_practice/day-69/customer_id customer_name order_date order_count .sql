/*Find customers who placed more than one order on the same calendar date.

Return:

customer_id
customer_name
order_date
order_count */


select dc.customer_id,
       dc.first_name,
       cast(order_date as DATE) as orderdate,
       count(distinct order_number) as total_orders
       from gold.fact_sales as fs
       left join gold.dim_customers as dc     
       on fs.customer_key = dc.customer_key
       group by customer_id , first_name, cast(order_date as DATE)
       having count(distinct order_number) > 1     
      
