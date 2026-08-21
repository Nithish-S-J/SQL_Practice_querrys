/* For each customer, calculate the number of orders per calendar month and
find customers who had at least 3 consecutive months where order count increased every month.

Return
customer_id
customer_name
start_month
end_month
starting_orders
ending_orders
months_in_streak */

with cte1 as
(
select dc.customer_id,
       dc.first_name as customer_name,
       DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
       count(order_number) as total_orders
         from gold.fact_sales as fs
         left join gold.dim_customers as dc
         on fs.customer_key = dc.customer_key
         group by dc.customer_id,
                  dc.first_name,
                  DATEFROMPARTS(year(order_date),month(order_date),1) 
                  )
                  , cte2 as
                  (select *,
                          lead(sales_month,1)over(partition by customer_id order by sales_month) as month_lead1,
                          lead(sales_month,2)over(partition by customer_id order by sales_month) as month_lead2,
                          lead(total_orders,1)over(partition by customer_id order by sales_month) as  order_lead1,
                          lead(total_orders,2)over(partition by customer_id order by sales_month) as  order_lead2
                          from cte1
                          )
                          , cte3 as
                          (select *,
                                  row_number()over(partition by customer_id order by sales_month)rn
                                  from cte2
                                  where datediff(month, sales_month, month_lead1) = 1
                                  and datediff(month, month_lead1, month_lead2) = 1
                                  and order_lead1 > total_orders
                                  and order_lead2 > order_lead1)

                          select customer_id,
                                 customer_name,
                                sales_month as start_month,
                                 month_lead2 as end_month,
                                 total_orders as starting_orders,
                                 order_lead2 as ending_orders,
                                 3 as months_in_streak,
                                 rn as number
                                 from cte3
                                 where  rn = 1
                                 order by customer_id
