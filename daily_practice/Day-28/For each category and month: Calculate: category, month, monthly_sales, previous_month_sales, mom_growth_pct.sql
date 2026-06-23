----For each category and month: Calculate: category, month, monthly_sales, previous_month_sales, mom_growth_pct

with cte1 as
(
select 
       dp.category,
       DATEFROMPARTS(year(order_date),month(order_date),1) as month,
       sum(sales_amount) as monthly_sales
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category, DATEFROMPARTS(year(order_date),month(order_date),1)
       )
  
       select *,
               lag(monthly_sales)over(partition by category order by month) as previous_month_sales,
              
               round(100.0*(monthly_sales - lag(monthly_sales)over(partition by category order by month))
               /
               lag(monthly_sales)over(partition by category order by month),2) as growth_pct
               from cte1
               
