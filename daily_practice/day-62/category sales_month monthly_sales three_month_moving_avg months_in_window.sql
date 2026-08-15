/*For every category and sales month, calculate the 3-row moving average of monthly sales.

The window consists of:

Current month
+
Previous 2 available monthly rows
Return
category
sales_month
monthly_sales
three_month_moving_avg
months_in_window */


with cte1 as
(
select   dp.category,
         DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
         sum(sales_amount) as monthly_sales
         from gold.fact_sales as fs
         left join gold.dim_products as dp
         on fs.product_key = dp.product_key
         group by dp.category,
                  DATEFROMPARTS(year(order_date),month(order_date),1) 
                  )
                 select *,
                          avg(monthly_sales)over(partition by category order by sales_month
                                                 rows between 2 preceding and current row) as three_row_moving_avg,
                                                 count(monthly_sales)over(partition by category order by sales_month
                                                 rows between 2 preceding and current row) months_in_window
                                                 from cte1
