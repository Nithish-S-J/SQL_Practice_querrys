/*Product leadership wants to identify the customers responsible for the majority of revenue within each product category.

For every category:

Calculate customer revenue.
Rank customers by revenue.
Calculate cumulative revenue percentage.
Identify customers belonging to the first 80% of category revenue.
Return
category
customer_id
customer_name
customer_revenue
category_revenue
running_revenue
running_revenue_pct */

with cte1 as
(
select dp.category,
       dc.customer_id,
       dc.first_name as customer_name,       
       sum(sales_amount) as customer_revenue
       from gold.fact_sales as fs
       left join gold.dim_customers dc
       on fs.customer_key = dc.customer_key
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by dp.category,
                dc.customer_id,
                dc.first_name
                )
                , cte2 as
                (select *,
                        sum(customer_revenue)over(partition by category ) as category_revenue,
                        sum(customer_revenue)over(partition by category order by customer_revenue desc) as running_revenue
                        from cte1
                        )
                        , cte3 as
                        (
                        select *,
                               round(100.0* running_revenue/category_revenue,2) as running_revenue_pct
                               from cte2
                               )
                               select * from cte3
                               where running_revenue_pct <=80
                               order by customer_revenue desc, running_revenue desc
