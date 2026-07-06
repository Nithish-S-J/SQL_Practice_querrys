----Find customer-month records where monthly sales were higher than the previous calendar month's sales.
----Return: customer_id, customer_name, sales_month, monthly_sales, previous_month_sales, sales_increase

with cte1 as 
(
select dc.customer_id,
       concat(dc.first_name,' ' ,dc.last_name) as customer_name,
       DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
       sum(sales_amount) as monthly_sales
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      group by dc.customer_id,  concat(dc.first_name,' ' ,dc.last_name),DATEFROMPARTS(year(order_date),month(order_date),1)
      )
      , prev_sales as 
      (select *,
              lag(sales_month)over(partition by customer_id order by sales_month) as previous_sales_month,
              lag(monthly_sales)over(partition by customer_id order by sales_month) as previous_month_sales
              from cte1)

              select *, 
                       monthly_sales - previous_month_sales as sales_increase
                       from prev_sales
             
             where datediff(month, previous_sales_month, sales_month) = 1
             and monthly_sales > previous_month_sales
