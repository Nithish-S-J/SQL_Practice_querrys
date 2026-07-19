/* Find customers who made a purchase after at least 3 complete calendar months of inactivity.

Return:

customer_id
customer_name
country
previous_purchase_month
reactivation_month
inactive_months */

with cte1 as
(
select dc.customer_id,
       concat(dc.first_name,' ',dc.last_name) as customer_name,
       dc.country,
       DATEFROMPARTS(year(order_date),month(order_date),1) as purchase_month      
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      )
      , cte2 as
      (select *,
              lag(purchase_month)over(partition by customer_id order by purchase_month) as previous_purchase_month
              from cte1
              )

              select *,
                     datediff(month, previous_purchase_month, purchase_month) - 1  as inactive_month
                     from cte2
                     where datediff(month, previous_purchase_month, purchase_month) > = 4
