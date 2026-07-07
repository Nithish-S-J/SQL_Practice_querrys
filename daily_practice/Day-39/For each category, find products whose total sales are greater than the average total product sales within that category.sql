----For each category, find products whose total sales are greater than the average total product sales within that category.
---Return:category, product_key, product_name, total_sales, category_avg_product_sales,sales_above_avg

with cte1 as
(
select 
      dp.category,
      dp.product_key,
      dp.product_name,
      sum(sales_amount) as total_sales
      from gold.fact_sales as fs
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      group by dp.category,dp.product_key,dp.product_name
      )
      ,avg_total as
      (select *,
              avg(total_sales)over(partition by category) as category_avg_product_sales
              from cte1
              )
              select 
                     category,
                     product_key,
                     product_name,
                     total_sales,
                     category_avg_product_sales,
                     total_sales - category_avg_product_sales as sales_above_avg
                     from avg_total
                     where total_sales > category_avg_product_sales
