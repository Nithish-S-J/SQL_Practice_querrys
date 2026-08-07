/* For every product, calculate its contribution to the total revenue of its category.

Also rank products by revenue within their category.

Return
category
product_key
product_name
product_revenue
category_revenue
product_contribution_pct
revenue_rank */

with cte1 as (

select        
      category,
      dp.product_key,
      product_name,
      sum(sales_amount) as product_revenue  

      from gold.fact_sales as fs
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      group by category, dp.product_key,dp.product_name
     )
     , cte2 as
     (
     select 
              *,
              sum(product_revenue)over(partition by category ) as category_revenue,
              dense_rank()over(partition by category order by product_revenue desc) as revenue_rank

              
              from cte1            
              )

              select *,
                      round(100.0* product_revenue / category_revenue, 2) as product_contribution_pct
                      from  cte2 
              
