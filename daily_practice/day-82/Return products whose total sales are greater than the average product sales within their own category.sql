/* Return products whose total sales are greater than the average product sales within their own category.

Return
category
product_key
product_name
total_sales
category_avg_product_sales
sales_difference */

with cte1 as
(
select dp.category,
       dp.product_key,
       dp.product_name,
       sum(sales_amount) as total_sales
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category,
                dp.product_key,
                dp.product_name
                )
                , cte2 as 
                (select category,
                        avg(total_sales) as avg_cat_prod_sales
                        from cte1
                        group by category)
                        select * from cte1 as c1
                        join cte2 as c2
                        on c1.category = c2.category
                        where c1.total_sales > c2.avg_cat_prod_sales
