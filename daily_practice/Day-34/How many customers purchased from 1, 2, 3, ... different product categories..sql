---Create a distribution table showing
---How many customers purchased from 1, 2, 3, ... different product categories.
---- Return, unique_categories, customer_count

WITH customer_categories AS
(
    SELECT
        dc.customer_id,
        COUNT(DISTINCT dp.category) AS unique_categories
    FROM gold.fact_sales AS fs
    INNER JOIN gold.dim_customers AS dc
        ON fs.customer_key = dc.customer_key
    INNER JOIN gold.dim_products AS dp
        ON fs.product_key = dp.product_key
    GROUP BY
        dc.customer_id
)
select unique_categories,
       count(*) as customer_count
       from customer_categories
       group by unique_categories 
       order by unique_categories
