--Find customers who: purchased, skipped 2 months, purchased, skipped 1 month, purchased

with cte1 as
(
select dc.customer_id,
       concat(dc.first_name,' ', dc.last_name) as customer_name,
       DATEFROMPARTS(year(order_date),month(order_date),1) as purchase_month
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      )
      , months as
      (select *,
              lead(purchase_month,1)over(partition by customer_id order by purchase_month) as lead1,
              lead(purchase_month,2)over(partition by customer_id order by purchase_month) as lead2
              from cte1
              )

              select customer_id,
                     customer_name,
                     purchase_month as first_purchase_month,
                     dateadd(month, 1, lead1)  as skipped_month2,
                     lead1 as second_purchase_month,
                     dateadd(month, 2, lead2) as skipped_month1,
                     lead2 as third_purchase_month
                     from months
                     where datediff(month, purchase_month, lead1) = 3
                     and datediff(month, lead1, lead2) = 2
      
