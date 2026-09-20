/* Find customers who made purchases in at least 3 consecutive calendar months.

Return
customer_id
customer_name
country
streak_start_month
streak_end_month
consecutive_months */

with cte1 as
(
select distinct
       dc.customer_id,
       dc.first_name as customer_name,
       dc.country,
       DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month
       from gold.fact_sales as fs
       left join gold.dim_customers as dc 
       on fs.customer_key = dc.customer_key
       )
       , cte2 as
       (select *, 
               lead(sales_month, 1)over(partition by customer_id order by sales_month) as next_month,
               lead(sales_month, 2)over(partition by customer_id order by sales_month) as third_month
               from cte1
               )
               SELECT
                     customer_id,
                     customer_name,
                     country,
                     sales_month AS streak_start_month,
                     third_month AS streak_end_month,
                     3 AS consecutive_months
                     FROM cte2
                     WHERE DATEDIFF(month, sales_month, next_month) = 1
                     AND DATEDIFF(month, next_month, third_month) = 1;
