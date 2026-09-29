/*For every customer's first purchase month, determine whether that customer made another purchase in the immediately following calendar month.

Return
customer_id
customer_name
first_purchase_month
next_month_purchase */

WITH cte1 AS
(
    SELECT DISTINCT
        dc.customer_id,
        dc.first_name AS customer_name,
        DATEFROMPARTS(YEAR(fs.order_date), MONTH(fs.order_date), 1) AS sales_month
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_customers AS dc
        ON fs.customer_key = dc.customer_key
),
cte2 AS
(
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY sales_month
        ) AS rn
    FROM cte1
),
cte3 AS
(
    SELECT
        *,
        LEAD(sales_month) OVER (
            PARTITION BY customer_id
            ORDER BY sales_month
        ) AS next_purchase_month
    FROM cte2
)
SELECT
    customer_id,
    customer_name,
    sales_month AS first_purchase_month,
    CASE
        WHEN DATEDIFF(month, sales_month, next_purchase_month) = 1
        THEN 'Yes'
        ELSE 'No'
    END AS next_month_purchase
FROM cte3
WHERE rn = 1;
