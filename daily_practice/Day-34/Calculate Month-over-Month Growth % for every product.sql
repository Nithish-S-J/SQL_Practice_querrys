---Calculate Month-over-Month Growth % for every product.
-- Return, product_name , month, monthly_sales, previous_month_sales, mom_growth_pct

with cte1 as
(
select
      dp.product_name,
      DATEFROMPARTS(year(order_date),month(order_date),1) as month,
      sum(sales_amount) as monthly_sales
      from gold.fact_sales as fs
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      group by dp.product_name, DATEFROMPARTS(year(order_date),month(order_date),1)
      )
      , prev_sales as
      (select *,
              lag(monthly_sales)over(partition by product_name order by month) as previous_month_sales
              from cte1
              )
              select product_name,
                     month,
                     monthly_sales,
                     previous_month_sales,
                     round(100.0*(monthly_sales - previous_month_sales)
                     /
                     nullif(previous_month_sales,0),2) as MOM_growth_pct
                     from prev_sales
