/*For every category calculate:

Highest monthly sales
Lowest monthly sales
Difference
Percentage variation

Return:

category
highest_monthly_sales
lowest_monthly_sales
sales_difference
variation_pct
Formula */

with cte1 as
(
select dp.category,
       DATEFROMPARTS(year(order_date),month(order_date),1) as order_month,
       sum(sales_amount) as total_sales
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category, DATEFROMPARTS(year(order_date),month(order_date),1)
       )
       
       select category,
               max(total_sales) as highest_monthly_sales,
               min(total_sales) as lowest_monthly_sales,
               max(total_sales) - min(total_sales) as sales_difernce,
               round(100.0*(max(total_sales) - min(total_sales))
               /
               min(total_sales) ,2) as variation_pct
               from cte1
               group by category
