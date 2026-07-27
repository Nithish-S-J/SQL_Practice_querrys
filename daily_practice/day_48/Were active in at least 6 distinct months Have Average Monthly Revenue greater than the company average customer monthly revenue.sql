/*For every customer, calculate:

First Purchase Month
Last Purchase Month
Active Months (distinct purchase months)
Total Revenue
Average Monthly Revenue

Return only customers who:

Were active in at least 6 distinct months
Have Average Monthly Revenue greater than the company average customer monthly revenue
Return
customer_id
customer_name
country
first_purchase_month
last_purchase_month
active_months
total_revenue
avg_monthly_revenue
company_avg_monthly_revenue */

WITH monthly_sales AS
(
    SELECT
        dc.customer_id,
        CONCAT(dc.first_name, ' ', dc.last_name) AS customer_name,
        dc.country,
        DATEFROMPARTS(YEAR(fs.order_date), MONTH(fs.order_date), 1) AS order_month,
        SUM(fs.sales_amount) AS monthly_revenue
    FROM gold.fact_sales fs
    INNER JOIN gold.dim_customers dc
        ON fs.customer_key = dc.customer_key
    GROUP BY
        dc.customer_id,
        CONCAT(dc.first_name, ' ', dc.last_name),
        dc.country,
        DATEFROMPARTS(YEAR(fs.order_date), MONTH(fs.order_date), 1)
),

customer_metrics AS
(
    SELECT
        customer_id,
        customer_name,
        country,
        MIN(order_month) AS first_purchase_month,
        MAX(order_month) AS last_purchase_month,
        COUNT(*) AS active_months,
        SUM(monthly_revenue) AS total_revenue,
        AVG(monthly_revenue) AS avg_monthly_revenue
    FROM monthly_sales
    GROUP BY
        customer_id,
        customer_name,
        country
),

final_result AS
(
    SELECT
        *,
        AVG(avg_monthly_revenue) OVER () AS company_avg_monthly_revenue
    FROM customer_metrics
)

SELECT
    customer_id,
    customer_name,
    country,
    first_purchase_month,
    last_purchase_month,
    active_months,
    total_revenue,
    ROUND(avg_monthly_revenue,2) AS avg_monthly_revenue,
    ROUND(company_avg_monthly_revenue,2) AS company_avg_monthly_revenue
FROM final_result
WHERE active_months >= 6
  AND avg_monthly_revenue > company_avg_monthly_revenue
ORDER BY total_revenue DESC;
