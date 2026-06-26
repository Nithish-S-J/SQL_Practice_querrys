----Find customers who: purchased in 2 consecutive months, skipped 1 month
-----purchased in 2 consecutive months again
---customer_id, customer_name, first_purchase_month, second_purchase_month, skipped_month
-- third_purchase_month, fourth_purchase_month

with cte1 as
(
select distinct
       dc.customer_id,
       concat(dc.first_name , ' ',dc.last_name) as customer_name,
       DATEFROMPARTS(year(order_date),month(order_date),1) as purchase_month
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       )
       , months as
       (select *,
              lead(purchase_month,1) over(partition by customer_id order by purchase_month) as lead1,
              lead(purchase_month,2) over(partition by customer_id order by purchase_month) as lead2,
              lead(purchase_month,3) over(partition by customer_id order by purchase_month) as lead3
              from cte1
              )

              select customer_id,
                     customer_name,
                     purchase_month as first_purchase_month,
                     lead1 as second_purchase_month,
                     dateadd(month, 1, lead1) as skipped_month,
                     lead2 as third_purchase_month,
                     lead3 as fourth_purchase_month
                     from months
                     where datediff(month, purchase_month, lead1) = 1
                     and   datediff(month, lead1 , lead2) = 2
                     and datediff(month, lead2, lead3) = 1
                     order by customer_id, purchase_month
