/* For every product, calculate:

Total Revenue
Number of Distinct Customers
Number of Orders

Return only those products that satisfy all of the following:

Purchased by at least 10 distinct customers
Total revenue is greater than the average product revenue across all products
Average revenue per customer is greater than 500
Return
product_key
product_name
category
total_revenue
customers
orders
avg_revenue_per_customer
company_avg_product_revenue */

with cte1 as
(
select dp.product_key,
       dp.product_name,
       dp.category,
       sum(sales_amount) as total_sales,
       count(distinct customer_id) as customers,
       count(distinct order_number) as orders,
       sum(sales_amount) / count(distinct customer_id) as avg_revenue_per_customer      
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       left join gold.dim_products as dp 
       on fs.product_key = dp.product_key
       group by dp.product_key,
                dp.product_name,
                dp.category
                )
                , cte2 as
                (
                select *,
                        avg(total_sales)over() as avg_product_revenue
                        from cte1
                        )

                        select *
                              from cte2
                              where customers >=10
                              and total_sales > avg_product_revenue
                              and avg_revenue_per_customer > 500
                       
                      

                       
                
