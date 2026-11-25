/* Using gold.fact_sales, calculate each customer's running total of sales over time.

Return:
- customer_key
- order_date
- order_number
- sales_amount
- running_sales */

SELECT
    customer_key,
    order_date,
    order_number,
    sales_amount,
    SUM(sales_amount) OVER (
        PARTITION BY customer_key
        ORDER BY order_date, order_number
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_sales
FROM gold.fact_sales;
