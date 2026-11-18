/* Return:
- sales_month
- total_sales
- previous_month_sales
- sales_growth_pct */

with cte1 as
(
select 
      datefromparts(year(order_date),month(order_date),1) as sales_month,
      sum(sales_amount) as total_sales
      from gold.fact_sales as fs
      group by datefromparts(year(order_date),month(order_date),1)
      )
      , cte2 as
      (
     select *,
              lag(total_sales) over (order by sales_month) as prev_month_sales              
              from cte1
              )
              select *,
                     round(100.0* ((total_sales - prev_month_sales ) / prev_month_sales),2) as growth_pct
                     from cte2

