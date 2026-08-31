WITH cte1 AS
(
    SELECT
        dc.customer_id,
        dc.first_name AS customer_name,
        dc.country,
        DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS first_purchase_month,
        SUM(sales_amount) AS first_month_revenue
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_customers AS dc
        ON fs.customer_key = dc.customer_key
    GROUP BY
        dc.customer_id,
        dc.first_name,
        dc.country,
        DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
),
cte2 AS
(
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY first_purchase_month
        ) AS rn
    FROM cte1
)
SELECT
    customer_id,
    customer_name,
    country,
    first_purchase_month,
    first_month_revenue
FROM cte2
WHERE rn = 1;
