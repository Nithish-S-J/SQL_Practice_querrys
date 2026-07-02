---For every customer, find whether they made another purchase within 30 days of their previous purchase.
---  Return, customer_id, customer_name, purchase_date, next_purchase_date, days_between

with cte1 as
(
select distinct
       dc.customer_id, 
       concat(dc.first_name,' ',dc.last_name) as customer_name,
       order_date as purchase_date
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      )
      , next_date as 
      (select *,
              lead(purchase_date)over(partition by customer_id order by purchase_date) as next_purchase_date
              from cte1
              )
              , day_betwin as
              (select *,
                      datediff(day, purchase_date, next_purchase_date) as days_between
                      from next_date)
                      select * from day_betwin
                      where days_between <=30
