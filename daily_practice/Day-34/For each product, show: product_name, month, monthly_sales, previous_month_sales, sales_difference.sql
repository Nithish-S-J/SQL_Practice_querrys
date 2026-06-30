---For each product, show: product_name, month, monthly_sales, previous_month_sales, sales_difference

with cte1 as
(
select 
      dp.product_name,
      DATEFROMPARTS(year(order_date), month(order_date),1) as month,
      sum(sales_amount) as monthly_sales
      from gold.fact_sales as fs
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      group by product_name, DATEFROMPARTS(year(order_date), month(order_date),1)
      )
      , prev_sales as
      (select *,
              lag(monthly_sales)over(partition by product_name order by month) as previous_month_sales
              from cte1
              )
              select *,
                     monthly_sales - previous_month_sales  as sales_differences
                     from prev_sales
