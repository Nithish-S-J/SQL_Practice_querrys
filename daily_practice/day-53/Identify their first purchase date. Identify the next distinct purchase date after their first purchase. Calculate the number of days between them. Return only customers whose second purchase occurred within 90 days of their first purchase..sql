/*Customer Analytics wants to measure how quickly first-time buyers make their next purchase.

For every customer:

Identify their first purchase date.
Identify the next distinct purchase date after their first purchase.
Calculate the number of days between them.
Return only customers whose second purchase occurred within 90 days of their first purchase.
Return
customer_id
customer_name
country
first_purchase_date
second_purchase_date
days_to_second_purchase */

with cte1 as
(
select distinct
      dc.customer_id,
      concat(dc.first_name , ' ' , dc.last_name) as customer_name,
      dc.country,
      order_date               
      from gold.fact_sales as fs
      left join gold.dim_customers as dc 
      on fs.customer_key = dc.customer_key
     )
     , cte2 as
     (select *,
             row_number()over(partition by customer_id order by order_date) as rn,
             lead(order_date)over(partition by customer_id order by order_date) as second_purchase_date
             from cte1
             )
             
             select 
                    customer_id,
                    customer_name,
                    country,
                    order_date  as first_purchase_date,
                 
                    second_purchase_date,
                    datediff(day, order_date, second_purchase_date) as days_between
                     from cte2
                     where rn = 1
                     and datediff(day, order_date, second_purchase_date)  <=90
