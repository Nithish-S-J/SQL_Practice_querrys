/*Management wants a report showing each product category's revenue by month.
For each category, return revenue for: January February March April 
Return category January February March April */

select category,
       sum(case when month(order_date) = 1 then sales_amount else 0 end) as january,
       sum(case when month(order_date) = 2 then sales_amount else 0 end) as february,
       sum(case when month(order_date) = 3 then sales_amount else 0 end) as march,
       sum(case when month(order_date) = 4 then sales_amount else 0 end) as april
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       group by category
