/*For each product, calculate its total revenue and its percentage contribution to total dataset revenue.
Return
product_key
product_name
category
total_revenue
revenue_contribution_pct */

with cte1 as
(
select dp.product_key,
       dp.product_name,
       dp.category,
       sum(sales_amount) as total_revenue
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.product_key,
                dp.product_name,
                dp.category
                )
                select *,
                        round(100* total_revenue / SUM(total_revenue) OVER (),2) as revenue_contribution_pct
                        from cte1
