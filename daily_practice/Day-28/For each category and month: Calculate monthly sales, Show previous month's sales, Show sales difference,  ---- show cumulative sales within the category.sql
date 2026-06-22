---For each category and month: Calculate monthly sales, Show previous month's sales, Show sales difference, 
---- show cumulative sales within the category,

with cte1 as
(
select 
       dp.category,
       DATEFROMPARTS(year(order_date), month(order_date),1) as month,
       sum(sales_amount) as monthly_sales
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category, DATEFROMPARTS(year(order_date), month(order_date),1)
       )
       select * from
       (select *,
               lag(monthly_sales)over(partition by category order by month) as prev_monthsale,
               (monthly_sales -lag(monthly_sales)over(partition by category order by month)) as salesdifrnce,

               sum(monthly_sales)over(partition by category order by month) as cumulative_sales               

               from cte1)t
       
