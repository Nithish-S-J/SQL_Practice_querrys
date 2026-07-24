/*Return only the months where:

The previous calendar month exists for that customer.
Revenue increased by at least 20% compared to the previous calendar month.
Return
customer_id
customer_name
sales_month
previous_month_sales
current_month_sales
growth_amount
growth_pct */

with cte1 as
(
select dc.customer_id,
       concat(dc.first_name, ' ', dc.last_name) as customer_name,
       DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
       sum(sales_amount) as current_month_sales  
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      group by dc.customer_id,
       concat(dc.first_name, ' ', dc.last_name) ,
       DATEFROMPARTS(year(order_date),month(order_date),1)
      )
      ,cte2 as
      (
    select *,
              lag(sales_month)over(partition by customer_id order by sales_month) as previous_month,
              lag(current_month_sales)over(partition by customer_id order by sales_month) as previous_month_sales,
              current_month_sales - lag(current_month_sales)over(partition by customer_id order by sales_month) as growth_amount,

              round(100.0* (current_month_sales - lag(current_month_sales)over(partition by customer_id order by sales_month))
               /
               lag(current_month_sales)over(partition by customer_id order by sales_month),2) as growth_pct

              from cte1
              )

              select *                     
                     from cte2
                     where datediff(month, previous_month, sales_month) = 1
                     and  growth_pct >=20
