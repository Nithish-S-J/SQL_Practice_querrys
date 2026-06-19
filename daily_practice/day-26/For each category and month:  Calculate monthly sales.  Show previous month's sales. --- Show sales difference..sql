----For each category and month:  Calculate monthly sales.  Show previous month's sales.
--- Show sales difference.

with cte1 as 
(
select  dp.category,
        FORMAT(order_date,'yyyy-MM') as month,
        sum(sales_amount) as monthly_sales 
        from gold.fact_sales as fs
        left join gold.dim_products as dp
        on fs.product_key = dp.product_key
        group by category, FORMAT(order_date,'yyyy-MM')
        )
        , cte2 as 
        (select *,
                lag(monthly_sales)over(partition by category order by month ) as prev_monthsales,
                monthly_sales - lag(monthly_sales)over(partition by category order by month ) as sales_diff
                from cte1)

                select *
                         from cte2
                       
                
