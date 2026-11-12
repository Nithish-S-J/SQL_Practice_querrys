/*For every customer, identify their longest streak of consecutive calendar months with at least one purchase.

Return
customer_id
customer_name
streak_start_month
streak_end_month
longest_streak_months */


WITH cte1 AS
(
    SELECT DISTINCT
        dc.customer_id,
        CONCAT(dc.first_name, ' ', dc.last_name) AS customer_name,
        DATEFROMPARTS(
            YEAR(order_date),
            MONTH(order_date),
            1
        ) AS sales_month
    FROM gold.fact_sales AS fs
    LEFT JOIN gold.dim_customers AS dc
        ON fs.customer_key = dc.customer_key
),

cte2 AS
(
    SELECT
        *,
        LAG(sales_month) OVER(
            PARTITION BY customer_id
            ORDER BY sales_month
        ) AS previous_month
    FROM cte1
),

cte3 AS
(
    SELECT
        *,
        CASE
            WHEN previous_month IS NULL
                 OR DATEDIFF(month, previous_month, sales_month) > 1
            THEN 1
            ELSE 0
        END AS new_streak
    FROM cte2
),

cte4 AS
(
    SELECT
        *,
        SUM(new_streak) OVER(
            PARTITION BY customer_id
            ORDER BY sales_month
            ROWS UNBOUNDED PRECEDING
        ) AS streak_id
    FROM cte3
),

cte5 AS
(
    SELECT
        customer_id,
        customer_name,
        streak_id,
        MIN(sales_month) AS streak_start_month,
        MAX(sales_month) AS streak_end_month,
        COUNT(*) AS streak_months
    FROM cte4
    GROUP BY
        customer_id,
        customer_name,
        streak_id
),

cte6 AS
(
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY streak_months DESC,
                     streak_start_month
        ) AS rn
    FROM cte5
)

SELECT
    customer_id,
    customer_name,
    streak_start_month,
    streak_end_month,
    streak_months AS longest_streak_months
FROM cte6
WHERE rn = 1
ORDER BY customer_id;
