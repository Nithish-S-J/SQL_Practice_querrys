---Find customers who purchased products from the same category in 4 consecutive months.

with cte1 as
(
select distinct
      dc.customer_id,
      dp.category,
      CONCAT(dc.first_name,' ',dc.last_name) as customer_name,
      DATEFROMPARTS(year(order_date),month(order_date),1) as activity_month
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      )
      , numbered as 
      (select *,
              row_number()over(partition by customer_id, category order by activity_month) as rn
              from cte1)
              , grouped as
              (select *,
                      DATEADD(month, -rn, activity_month) as grp
                      from numbered)
                      , streak as
                      (select customer_id,                           
                              category,
                              min(activity_month) as start_date,
                              max(activity_month) as end_date,
                              count(*) as month_number
                              from grouped
                              group by customer_id, category, grp
                              )

                              select Customer_id,                                  
                                     category,
                                     start_date,
                                     end_date,
                                     month_number
                                     from streak
                                     where month_number >=3
                                     order by customer_id, start_date 
