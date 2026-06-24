---Find customers who purchased in three alternate months.
---Output: customer_id, customer_name, start_month, end_month

with cte1 as
(
select 
      customer_id,
      concat(dc.first_name,' ',dc.last_name) as customer_name,
      DATEFROMPARTS(year(order_date), month(order_date),1) purchase_month
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      )
      , alternate_months as 
      (select *,
              lead(purchase_month,1)over(partition by customer_id order by purchase_month) as lead1,
              lead(purchase_month,2)over(partition by customer_id order by purchase_month) as lead2             
              from cte1
              )
              select customer_id,
                     customer_name,
                     purchase_month
                     from alternate_months
                     where DATEDIFF(month, purchase_month, lead1) = 2
                            and datediff(month, lead1, lead2) = 2
