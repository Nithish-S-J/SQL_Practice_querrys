--Find products that belong to the Top 3 sales ranks within their category.
---category , product_name, total_sales, dense_rank

with cte1 as
(
select dp.category,
       dp.product_name,
      sum(fs.sales_amount) as totalsales,
      dense_rank()over(partition by category order by sum(fs.sales_amount)desc) as dense_rank
      from gold.fact_sales as fs
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      group by dp.category,dp.product_name
      )
       
      select 
             category,
             product_name,
             totalsales,
             dense_rank
             from cte1
             where dense_rank <=3
