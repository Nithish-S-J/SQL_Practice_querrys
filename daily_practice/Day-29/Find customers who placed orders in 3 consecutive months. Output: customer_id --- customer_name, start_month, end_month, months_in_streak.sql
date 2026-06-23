----Find customers who placed orders in 3 consecutive months. Output: customer_id
--- customer_name, start_month, end_month, months_in_streak

with cte1 as
(
select 
      dc.customer_id,
      CONCAT(dc.first_name, ' ' ,dc.last_name) as customer_name,
      datefromparts(year(order_date), month(order_date),1) as activity_month
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      )
                , numbered as
                (select *,
                        row_number()over(partition by customer_id order by activity_month) as rn
                        from cte1
                        )
                        , grouped as 
                        (select *,
                                DATEADD(month, -rn, activity_month) as grp
                                from numbered
                                )
                                , streak as 
                                (select customer_id,
                                        customer_name,
                                        min(activity_month) as start_month,
                                        max(activity_month) as end_month,
                                        count(*) as months_in_streak
                                        from grouped
                                        group by customer_id, customer_name, grp
                                        )
                                        select 
                                               customer_id,
                                               customer_name,
                                               start_month,
                                               end_month,
                                               months_in_streak
                                               from streak
                                               where months_in_streak >=3
                                               order by customer_id, start_month

                                
                
