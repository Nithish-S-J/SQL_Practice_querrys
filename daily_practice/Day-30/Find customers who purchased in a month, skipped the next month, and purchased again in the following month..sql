
------Find customers who purchased in a month, skipped the next month, and purchased again in the following month.



with cte1 as
(
select 
       dc.customer_id,
       concat(dc.first_name,' ',dc.last_name) as customer_name,
       datefromparts(year(order_date), month(order_date),1) as purchase_month
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       )
       , next_month_check as
       (select *,
               lead(purchase_month)over(partition by customer_id order by purchase_month) as next_purchase_month
               from cte1
               )
               select customer_id,
                      customer_name,
                      purchase_month,
                      next_purchase_month
                      from next_month_check
                      where datediff(month, purchase_month, next_purchase_month) = 2
                      order by customer_id , purchase_month
