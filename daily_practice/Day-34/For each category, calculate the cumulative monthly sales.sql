---For each category, calculate the cumulative monthly sales.
-----Return category, month, monthly_sales, running_sales

with cte1 as
(
select dp.category,
      DATEFROMPARTS(year(order_date), month(order_date),1) as month,
      sum(sales_amount) as monthly_sales
      from gold.fact_sales as fs
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      group by dp.category,    DATEFROMPARTS(year(order_date), month(order_date),1) )
     select *,
              sum(monthly_sales)over(partition by category order by month ) as running_sales
              from cte1
