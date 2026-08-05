/* Find customers who have purchased products from every distinct category that has appeared in the sales dataset.

Return
customer_id
customer_name
country
categories_purchased
total_sales_categories
total_revenue */

with cte1 as
(
select 
       dc.customer_id,
       dc.first_name,
       dc.country,
    
       sum(sales_amount) as total_revenue,
       count(distinct category) as total_categories
       from gold.fact_sales as fs
       inner join gold.dim_customers as dc
       on fs. customer_key = dc.customer_key
       inner join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by 
       dc.customer_id,
       dc.first_name,
       dc.country
       )
       , cte2 as
       (SELECT
    COUNT(DISTINCT dp.category) AS total_sales_categories
FROM gold.fact_sales AS fs
INNER JOIN gold.dim_products AS dp
    ON fs.product_key = dp.product_key )

    SELECT
    c1.customer_id,
    c1.first_name AS customer_name,
    c1.country,
    c1.total_categories AS categories_purchased,
    c2.total_sales_categories,
    c1.total_revenue
FROM cte1 AS c1
CROSS JOIN cte2 AS c2
WHERE c1.total_categories = c2.total_sales_categories
