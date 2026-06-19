--For each category: Calculate: Month, Monthly Sales 
--- Previous Month Sales MoM Growth %

with cte1 as 
(
select  dp.category,
        format(order_date,'yyyy-mm') as month,
        sum(fs.sales_amount) as current_sales
        from gold.fact_sales as fs
        left join gold.dim_products as dp
        on fs.product_key = dp.product_key
        group by dp.category, format(order_date,'yyyy-mm')
        )
        , prevsales as
        (select *,
                lag( current_sales)over(partition by category order by month) as prev_monthsales
                from cte1)

                select *,
                       round(100.0*(current_sales - prev_monthsales)/nullif(prev_monthsales,0),2) as momgrowth_pct
                       from prevsales
