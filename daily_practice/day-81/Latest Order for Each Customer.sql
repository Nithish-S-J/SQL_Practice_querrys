WITH cte1 AS
(
    SELECT
        dc.customer_id,
        dc.first_name AS customer_name,
        dc.country,
        fs.order_number,
        fs.order_date,
        SUM(fs.sales_amount) AS latest_order_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY dc.customer_id
            ORDER BY fs.order_date DESC
        ) AS rn
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_customers AS dc
        ON fs.customer_key = dc.customer_key
    GROUP BY
        dc.customer_id,
        dc.first_name,
        dc.country,
        fs.order_number,
        fs.order_date
)
SELECT
    customer_id,
    customer_name,
    country,
    order_number AS latest_order_number,
    order_date AS latest_order_date,
    latest_order_revenue
FROM cte1
WHERE rn = 1;
