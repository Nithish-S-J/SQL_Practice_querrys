--Find the Top 3 products by total sales within each category.

--category
--product_name
---total_sales
---rank

with cte1 as
(
select dp.category,
       dp.product_name,
       dp.product_key,
       sum(fs.sales_amount) as totalsales,
       dense_rank()over(partition by dp.category order by sum(fs.sales_amount)desc) as rank
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category, dp.product_name, dp.product_key
       )
       select 
                category,
                product_name,
                totalsales,
                rank
                from cte1
                where rank <=3
