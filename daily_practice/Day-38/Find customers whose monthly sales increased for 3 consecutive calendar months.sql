-----Find customers whose monthly sales increased for 3 consecutive calendar months.
---Return:customer_id, customer_name, start_month, end_month, starting_sales, ending_sales

with cte1 as
(
select dc.customer_id, 
       concat(dc.first_name, ' ',dc.last_name) as customer_name,
       DATEFROMPARTS(year(order_date),month(order_date),1) as order_months,
       sum(sales_amount) as total_sales
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.customer_id, concat(dc.first_name, ' ',dc.last_name),DATEFROMPARTS(year(order_date),month(order_date),1)
       )
       , nextt_months_sales as
       (select *,
               lead(total_sales,1)over(partition by customer_id order by order_months) as sales1,
               lead(total_sales,2)over(partition by customer_id order by order_months) as sales2,
               lead(order_months,1)over(partition by customer_id order by order_months) as month1,
               lead(order_months,2)over(partition by customer_id order by order_months) as month2
               from cte1
              )
              select customer_id, 
                     customer_name,
                     order_months as start_month,
                     month2 as end_month,
                     total_sales as starting_sales,
                     sales2 as ending_sales                      
                     from nextt_months_sales
              where datediff(month, order_months, month1) = 1
              and datediff(month, month1, month2) = 1
              and sales1>total_sales
              and sales2>sales1
