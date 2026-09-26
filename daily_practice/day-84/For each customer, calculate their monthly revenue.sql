/* For each customer, calculate their monthly revenue
   and the revenue from their previous active purchase month.

Return:

customer_id
customer_name
sales_month
monthly_revenue
previous_month_revenue
revenue_change
*/

WITH cte1 AS
(
    SELECT
        dc.customer_id,
        dc.first_name AS customer_name,
        DATEFROMPARTS(YEAR(fs.order_date), MONTH(fs.order_date), 1) AS sales_month,
        SUM(fs.sales_amount) AS monthly_revenue
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
        LAG(monthly_revenue) OVER (
            PARTITION BY customer_id
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM cte1
)
SELECT
    customer_id,
    customer_name,
    sales_month,
    monthly_revenue,
    previous_month_revenue,
    monthly_revenue - previous_month_revenue AS revenue_change
FROM cte2;
