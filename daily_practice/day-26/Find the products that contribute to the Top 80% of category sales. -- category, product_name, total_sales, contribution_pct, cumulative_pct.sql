---Find the products that contribute to the Top 80% of category sales.
-- category, product_name, total_sales, contribution_pct, cumulative_pct

with cte1 as
(
select dp.category,
       dp.product_name,
       sum(fs.sales_amount) as total_sales
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category, dp.product_name
       )
       select * from 
       ( select *,
       sum(total_sales)over(partition by category) as category_sales,
       sum(total_sales)over(partition by category order by total_sales desc) as running_sales,

       round(100.0 * total_sales /
       sum(total_sales)over(partition by category),2) as contirbution_pct,

       100.0*sum(total_sales)over(partition by category order by total_sales desc)
       /
       sum(total_sales)over(partition by category) as cumulative_pct

       from cte1)t
       where cumulative_pct<=80
