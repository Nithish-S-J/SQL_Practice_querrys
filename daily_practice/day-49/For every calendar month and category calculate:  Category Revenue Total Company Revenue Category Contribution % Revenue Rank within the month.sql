/*For every calendar month and category calculate:

Category Revenue
Total Company Revenue
Category Contribution %
Revenue Rank within the month

Return:

sales_month
category
category_revenue
company_revenue
category_contribution_pct
revenue_rank */

with cte1 as
(
select 
        dp.category,
        DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
        sum(sales_amount) as category_revenue
        from gold.fact_sales as fs
        left join gold.dim_products as dp
        on fs.product_key = dp.product_key
        group by dp.category,
                 DATEFROMPARTS(year(order_date),month(order_date),1)
                 )
                 
                 select *,
                         sum(category_revenue)over(partition by sales_month) as company_revenue,
                         round(100.0* category_revenue / sum(category_revenue)over(partition by sales_month),2) as category_contribution_pct,
                         rank()over(partition by sales_month order by category_revenue desc) as revenue_rank
                         from cte1
