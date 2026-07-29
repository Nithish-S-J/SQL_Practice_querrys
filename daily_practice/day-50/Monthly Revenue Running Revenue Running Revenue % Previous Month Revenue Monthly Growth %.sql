/* For every calendar month calculate:

Monthly Revenue
Running Revenue
Running Revenue %
Previous Month Revenue
Monthly Growth %
Return
sales_month
monthly_revenue
running_revenue
running_revenue_pct
previous_month_revenue
growth_pct */

with cte1 as
(
select 
       DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
       sum(sales_amount) as monthly_revenue
       from gold.fact_sales
       group by DATEFROMPARTS(year(order_date),month(order_date),1)
       )
       , cte2 as
       (select *,
              sum(monthly_revenue)over(order by sales_month) as running_revenue,
              round(100.0* sum(monthly_revenue)over(order by sales_month) / sum(monthly_revenue)over(),2) as running_revenue_pct,
              lag(monthly_revenue)over(order by sales_month) as previous_month_revenue,
              round(100.0*   (monthly_revenue - lag(monthly_revenue)over(order by sales_month))
              /
              lag(monthly_revenue)over(order by sales_month),2) as growth_pct
              from cte1
              )
              select * from cte2
