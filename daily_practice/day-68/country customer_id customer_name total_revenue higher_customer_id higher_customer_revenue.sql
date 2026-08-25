/*Return customers who have a higher-revenue customer in the same country.

Return
country
customer_id
customer_name
total_revenue
higher_customer_id
higher_customer_revenue */



WITH cte1 AS
(
    SELECT
        dc.country,
        dc.customer_id,
        dc.first_name AS customer_name,
        SUM(sales_amount) AS total_revenue
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_customers AS dc
        ON fs.customer_key = dc.customer_key
    GROUP BY
        dc.country,
        dc.customer_id,
        dc.first_name
)

SELECT
    c1.country,
    c1.customer_id,
    c1.customer_name,
    c1.total_revenue,
    c2.customer_id AS higher_customer_id,
    c2.total_revenue AS higher_customer_revenue
FROM cte1 AS c1
JOIN cte1 AS c2
    ON c1.country = c2.country
    AND c2.total_revenue > c1.total_revenue
ORDER BY
    c1.country,
    c1.total_revenue DESC;
