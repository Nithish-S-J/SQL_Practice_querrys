---Find products that were sold in 6 consecutive months.

with cte1 as
(
select 
      dp.product_key,
      dp.product_name,
      datefromparts(year(order_date),month(order_date),1) as activity_month
      from gold.fact_sales as fs
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      )
      , numbered as
      (select *,
              row_number()over(partition by product_key order by activity_month) as rn
              from cte1
              )
              , grouped as
              (select *,
                      DATEADD(month, -rn, activity_month) as grp
                      from numbered)
                      , streak as
                      (select product_key,
                              product_name,
                              min(activity_month) as start_date,
                              max(activity_month) as end_date,
                              count(*) as month_number
                              from grouped
                              group by product_key, product_name, grp
                              )

                              select product_key,
                                     product_name,
                                     start_date,
                                     end_date,
                                     month_number
                                     from streak
                                     where month_number >=5
                                    order by product_key, start_date
