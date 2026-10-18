/*For every product, determine:

Total distinct customers
Customers who purchased the product at least twice
Repeat customer %
Average days between a customer's first and second purchase of that product
Total revenue
Return
product_key
product_name
category
total_customers
repeat_customers
repeat_customer_pct
avg_days_to_second_purchase
total_revenue */


with cte1 as
(
select dp.product_key,
       dp.product_name,
       dp.category,
       order_date,
       dc.customer_id,
       row_number()over(partition by dp.product_key , dc.customer_id order by order_date) as rn
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       )
       , cte2 as
       (select product_key,
               product_name,
               category,
               customer_id,
               max(case when rn = 1 then order_date end) as first_purchase_month,
               max(case when rn = 2 then order_date end) as second_purchase_month
               from cte1
               group by product_key,
                        product_name,
                        category,
                        customer_id
                        )
                        , cte3 as 
                        (select product_key,
                                product_name,
                                category,
                                count(*) as total_customers,
                                count(second_purchase_month) as repeat_customer,
                                avg(datediff (day, first_purchase_month, second_purchase_month)) as avg_days_between
                                from cte2
                                group by product_key,product_name,category
                                )

                                select  c3.product_key,
                                        c3.product_name,
                                        c3.category,
                                        c3.total_customers,
                                        c3.repeat_customer,
                                        round(100.0*  repeat_customer / total_customers,2) as repeat_cus_pct,
                                         c3.avg_days_between,
                                         SUM(fs.sales_amount) AS total_revenue
                                         FROM cte3 AS c3
                                         JOIN gold.fact_sales AS fs
                                         ON c3.product_key = fs.product_key
                                         GROUP BY
                                                   c3.product_key,
                                                   c3.product_name,
                                                   c3.category,
                                                   c3.total_customers,
                                                   c3.repeat_customer,
                                                   c3.avg_days_between
