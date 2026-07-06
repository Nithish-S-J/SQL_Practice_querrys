----For every customer, find their longest streak of consecutive purchase months.
----Return: customer_id, customer_name, streak_start_month, streak_end_month, longest_streak_months

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
             , grouped as
             (select *,
                     dateadd(month, -rn, order_month) as month_number
                     from numbered
                     )
                     , streak as 
                     (select customer_id,
                             customer_name,
                             month_number,
                             min(order_month) as streak_start_month,
                             max(order_month) as streak_end_month,
                             count(*) as longest_streak_months
                              from grouped
                              group by customer_id,customer_name,month_number
                              )
                              , ranked as
                              (select *,
                                      row_number()over(partition by customer_id order by longest_streak_months desc,streak_start_month asc )
                                                       as rn
                                                       from streak)

                                                       select * from ranked
                                                       where rn = 1
                                                       order by customer_id
