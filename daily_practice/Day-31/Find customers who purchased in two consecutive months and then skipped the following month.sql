--Find customers who purchased in two consecutive months and then skipped the following month.
---Output, customer_id, customer_name , first_purchase_month, second_purchase_month, skipped_month

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
       , numbered as
       (select *,              
               lead(purchase_month,1)over(partition by customer_id order by purchase_month) as lead1,
               lead(purchase_month,2)over(partition by customer_id order by purchase_month) as lead2
               from cte1
               )
                select *
                       from numbered
                      where  DATEDIFF(month, purchase_month, lead1) = 1 and datediff(month, lead1, lead2) =2
                       
