/* For each customer's first three distinct purchase months, calculate:

First purchase month
Second purchase month
Third purchase month
Days from first → second purchase
Days from second → third purchase
Total revenue across first three purchase months

Return only customers who reached Stage 3.
*/

WITH cte1 AS
(
    SELECT
        dc.customer_id,
        dc.first_name AS customer_name,
        dc.country,

        DATEFROMPARTS(
            YEAR(fs.order_date),
            MONTH(fs.order_date),
            1
        ) AS purchase_month,

        SUM(fs.sales_amount) AS monthly_revenue

    FROM gold.fact_sales AS fs

    LEFT JOIN gold.dim_customers AS dc
        ON fs.customer_key = dc.customer_key

    GROUP BY
        dc.customer_id,
        dc.first_name,
        dc.country,
        DATEFROMPARTS(
            YEAR(fs.order_date),
            MONTH(fs.order_date),
            1
        )
),

cte2 AS
(
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY purchase_month
        ) AS rn

    FROM cte1
),

cte3 AS
(
    SELECT
        customer_id,
        customer_name,
        country,

        MAX(CASE WHEN rn = 1 THEN purchase_month END)
            AS first_purchase_month,

        MAX(CASE WHEN rn = 2 THEN purchase_month END)
            AS second_purchase_month,

        MAX(CASE WHEN rn = 3 THEN purchase_month END)
            AS third_purchase_month,

        SUM(
            CASE
                WHEN rn <= 3 THEN monthly_revenue
                ELSE 0
            END
        ) AS first_three_month_revenue

    FROM cte2

    GROUP BY
        customer_id,
        customer_name,
        country
)

SELECT
    customer_id,
    customer_name,
    country,
    first_purchase_month,
    second_purchase_month,
    third_purchase_month,

    DATEDIFF(
        DAY,
        first_purchase_month,
        second_purchase_month
    ) AS days_first_to_second,

    DATEDIFF(
        DAY,
        second_purchase_month,
        third_purchase_month
    ) AS days_second_to_third,

    first_three_month_revenue

FROM cte3

WHERE third_purchase_month IS NOT NULL

ORDER BY customer_id;
