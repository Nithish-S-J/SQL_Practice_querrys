/* For every product, determine:

Total distinct customers
Customers who purchased the product at least twice
Repeat customer %
Average days between a customer's first and second purchase of that product
Total revenue
*/

WITH cte1 AS
(
    SELECT
        dp.product_key,
        dp.product_name,
        dp.category,
        dc.customer_id,
        fs.order_date,

        ROW_NUMBER() OVER(
            PARTITION BY dp.product_key, dc.customer_id
            ORDER BY fs.order_date
        ) AS rn

    FROM gold.fact_sales AS fs

    LEFT JOIN gold.dim_customers AS dc
        ON fs.customer_key = dc.customer_key

    LEFT JOIN gold.dim_products AS dp
        ON fs.product_key = dp.product_key
),

cte2 AS
(
    SELECT
        product_key,
        product_name,
        category,
        customer_id,

        MAX(
            CASE
                WHEN rn = 1 THEN order_date
            END
        ) AS first_purchase_date,

        MAX(
            CASE
                WHEN rn = 2 THEN order_date
            END
        ) AS second_purchase_date

    FROM cte1

    GROUP BY
        product_key,
        product_name,
        category,
        customer_id
),

cte3 AS
(
    SELECT
        product_key,
        product_name,
        category,
        customer_id,
        first_purchase_date,
        second_purchase_date,

        DATEDIFF(
            DAY,
            first_purchase_date,
            second_purchase_date
        ) AS days_to_second_purchase

    FROM cte2
),

cte4 AS
(
    SELECT
        product_key,
        COUNT(*) AS total_customers,

        COUNT(
            CASE
                WHEN second_purchase_date IS NOT NULL
                THEN 1
            END
        ) AS repeat_customers,

        AVG(
            CAST(days_to_second_purchase AS DECIMAL(10,2))
        ) AS avg_days_to_second_purchase

    FROM cte3

    GROUP BY product_key
),

cte5 AS
(
    SELECT
        product_key,
        SUM(sales_amount) AS total_revenue

    FROM gold.fact_sales

    GROUP BY product_key
)

SELECT
    c4.product_key,
    dp.product_name,
    dp.category,

    c4.total_customers,
    c4.repeat_customers,

    ROUND(
        100.0 * c4.repeat_customers / NULLIF(c4.total_customers, 0),
        2
    ) AS repeat_customer_pct,

    ROUND(
        c4.avg_days_to_second_purchase,
        2
    ) AS avg_days_to_second_purchase,

    c5.total_revenue

FROM cte4 AS c4

LEFT JOIN cte5 AS c5
    ON c4.product_key = c5.product_key

LEFT JOIN gold.dim_products AS dp
    ON c4.product_key = dp.product_key

ORDER BY c4.product_key;
