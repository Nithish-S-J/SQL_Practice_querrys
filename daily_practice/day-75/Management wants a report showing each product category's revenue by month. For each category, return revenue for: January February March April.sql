/*Management wants a report showing each product category's revenue by month.
For each category, return revenue for:
January
February
March
April

Return

category
January
February
March
April */

select dp.category,
        SUM(CASE WHEN MONTH(fs.order_date) = 1 THEN fs.sales_amount ELSE 0 END) AS January,
    SUM(CASE WHEN MONTH(fs.order_date) = 2 THEN fs.sales_amount ELSE 0 END) AS February,
    SUM(CASE WHEN MONTH(fs.order_date) = 3 THEN fs.sales_amount ELSE 0 END) AS March,
    SUM(CASE WHEN MONTH(fs.order_date) = 4 THEN fs.sales_amount ELSE 0 END) AS April
         from gold.fact_sales as fs
         left join gold.dim_products as dp 
         on fs.product_key = dp.product_key
         group by dp.category


