--Find customers who purchased in 4 consecutive months. 
--- Return customer_id, customer_name, start_month, end_month,

with cte1 as
(
select distinct
       dc.customer_id,
       concat(dc.first_name,' ',dc.last_name) as customer_name,
       DATEFROMPARTS(year(order_date),month(order_date),1) as order_month
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      )
      , numbered as
      (select *,
              row_number()over(partition by customer_id order by order_month) as rn
              from cte1
              )
              , months as 
              (select *,
                      dateadd(month, -rn, order_month) as month_date
                      from numbered
                      )
                      , streak as
                      (select customer_id,
                              customer_name,
                              month_date,
                              min(order_month) as start_month,
                              max(order_month) as end_month,
                              count(*) as monthnumber
                              from months
                              group by customer_id, customer_name, month_date
                              )
                              select * from streak
                              where monthnumber > = 13
                             
