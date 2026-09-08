/* Find customers who placed more than one distinct order on the same calendar date.

Return:

customer_id
customer_name
order_date
order_count */

select distinct 
       dc.customer_id,
       dc.first_name,
       fs.order_date,
       count(distinct order_number) as order_count
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.customer_id,
                dc.first_name,
                fs.order_date
                having count(distinct order_number) >1
