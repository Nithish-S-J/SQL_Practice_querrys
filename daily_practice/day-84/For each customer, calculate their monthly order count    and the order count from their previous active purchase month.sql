/* For each customer, calculate their monthly order count
   and the order count from their previous active purchase month.

Return:

customer_id
customer_name
sales_month
monthly_order_count
previous_month_order_count
order_count_change
*/
WITH cte1 AS
(
    SELECT
        dc.customer_id,
        dc.first_name AS customer_name,
        DATEFROMPARTS(YEAR(fs.order_date), MONTH(fs.order_date), 1) AS sales_month,
        COUNT(DISTINCT fs.order_number) AS monthly_order_count
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_customers AS dc
        ON fs.customer_key = dc.customer_key
    GROUP BY
        dc.customer_id,
        dc.first_name,
        DATEFROMPARTS(YEAR(fs.order_date), MONTH(fs.order_date), 1)
),
cte2 AS
(
    SELECT
        *,
        LAG(monthly_order_count) OVER (
            PARTITION BY customer_id
            ORDER BY sales_month
        ) AS previous_month_order_count
    FROM cte1
)
SELECT
    customer_id,
    customer_name,
    sales_month,
    monthly_order_count,
    previous_month_order_count,
    monthly_order_count - previous_month_order_count AS order_count_change
FROM cte2;
