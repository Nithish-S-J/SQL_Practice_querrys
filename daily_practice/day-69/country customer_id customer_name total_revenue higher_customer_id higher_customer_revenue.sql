/* Return customers who have a higher-revenue customer in the same country.

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
),

cte2 AS
(
    SELECT
        *,
        LEAD(customer_id) OVER(
            PARTITION BY country
            ORDER BY total_revenue
        ) AS higher_customer_id,

        LEAD(total_revenue) OVER(
            PARTITION BY country
            ORDER BY total_revenue
        ) AS higher_customer_revenue
    FROM cte1
)

SELECT
    country,
    customer_id,
    customer_name,
    total_revenue,
    higher_customer_id,
    higher_customer_revenue
FROM cte2
WHERE higher_customer_id IS NOT NULL
ORDER BY
    country,
    total_revenue DESC;
