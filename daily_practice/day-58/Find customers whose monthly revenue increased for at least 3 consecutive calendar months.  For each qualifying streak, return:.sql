/* Find customers whose monthly revenue increased for at least 3 consecutive calendar months.

For each qualifying streak, return:

customer_id
customer_name
start_month
end_month
starting_sales
ending_sales
months_in_streak */

with cte1 as
(
select   dc.customer_id,
         dc.first_name as customer_name,
         DATEFROMPARTS(year(order_date),month(order_date),1) as start_month,
         sum(sales_amount) as starting_sales        
        from gold.fact_sales as fs
        left join gold.dim_customers as dc
        on fs.customer_key = dc.customer_key
        group by dc.customer_id,
                 dc.first_name,
                 DATEFROMPARTS(year(order_date),month(order_date),1)
                 )
                 , cte2 as
                 (select 
                         *,
                         lead(start_month,1)over(partition by customer_id order by start_month) as month1,
                         lead(start_month,2)over(partition by customer_id order by start_month) as month2,
                         lead(starting_sales,1)over(partition by customer_id order by start_month) as sales1,
                         lead(starting_sales,2)over(partition by customer_id order by start_month) as sales2

                         from cte1
                         )
                          select customer_id, 
                     customer_name,
                     start_month as start_month,
                     month2 as end_month,
                     starting_sales as starting_sales,
                     sales2 as ending_sales ,
                     3 AS months_in_streak
                     from cte2
              where datediff(month, start_month, month1) = 1
              and datediff(month, month1, month2) = 1
              and sales1>starting_sales
              and sales2>sales1
