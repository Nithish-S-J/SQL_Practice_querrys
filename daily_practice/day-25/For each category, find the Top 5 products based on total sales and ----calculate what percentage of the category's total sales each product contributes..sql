---For each category, find the Top 5 products based on total sales and
----calculate what percentage of the category's total sales each product contributes.

with cte1 as 
(
select dp.category,
       fs.product_key,
       dp.product_name,
       sum(fs.sales_amount) as total_sales
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category,  dp.product_name, fs.product_key
       )
       , product_rank as
       (select *,
               DENSE_RANK()over(partition by category order by total_sales desc) as rn,
               sum(total_sales)over(partition by category) as category_sales
               from cte1)
              
                       select p.category,
                              product_name,
                              total_sales,
                              category_sales,
                              rn as product_rank,
                              round(100*p.total_sales/category_sales,2) as contribution_percent
                              from product_rank as p
                              where rn<=5
                              order by p.category, total_sales desc
       
                            
