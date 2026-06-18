---For each category, find the product that generated the highest total revenue.



with cte1 as 
(
select  dp.category,
        dp.product_name,
        sum(sales_amount) as total_sales,
       rank()over(partition by category order by sum(sales_amount)desc) as rank
        from gold.fact_sales as fs
        left join gold.dim_products as dp
        on fs.product_key = dp.product_key
        group by dp.category,dp.product_name
        )
        
         select category,
                product_name,
                total_sales
                from cte1
                where rank = 1
