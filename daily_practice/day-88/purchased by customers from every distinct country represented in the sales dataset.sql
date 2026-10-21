/* Find products that have been purchased by customers from every distinct country represented in the sales dataset.
Return
product_key
product_name
countries_purchased
total_countries */

with cte1 as
(
select fs.product_key,
       dp.product_name,
       count(distinct dc.country) as countries_purchased
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by fs.product_key,
                dp.product_name
                )
                ,cte2 AS
                 (
                   SELECT
                          COUNT(DISTINCT dc.country) AS total_countries
                          FROM gold.fact_sales AS fs
                          LEFT JOIN gold.dim_customers AS dc
                          ON fs.customer_key = dc.customer_key
                          )
                          select
                                c1.product_key,
                                c1.product_name,
                                c1.countries_purchased,
                                c2.total_countries
                                from cte1 as c1
                                cross join cte2 as c2
                                where c1.countries_purchased = c2.total_countries
