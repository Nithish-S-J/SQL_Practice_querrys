---Find customers who: purchased in 2 consecutive months  skipped the next 2 months
---- then purchased again in the following month

with cte1 as
(
select distinct
       customer_id,
       concat(dc.first_name,' ',dc.last_name) as customer_name,
       DATEFROMPARTS(year(order_date), month(order_date),1) as purchase_month
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       )
       ,months as
       (select *,
               lead(purchase_month,1)over(partition by customer_id order by purchase_month) as lead1,
               lead(purchase_month,2)over(partition by customer_id order by purchase_month) as lead2,
               lead(purchase_month,3)over(partition by customer_id order by purchase_month) as lead3
               from cte1
               )

               select *
               from months 
               where datediff(month, purchase_month, lead1) = 1
               and   datediff(month, lead1, lead2) = 3
