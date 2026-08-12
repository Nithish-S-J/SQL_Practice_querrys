/*Product Management wants to identify products with strong repeat-purchase behavior.
For every product calculate:
Distinct customers who purchased it
Customers who purchased it in 2 or more distinct calendar months
Repeat customer %
Total revenue
Return only products where the repeat customer percentage is at least 30%.
Return
product_key
product_name
category
total_customers
repeat_customers
repeat_customer_pct
total_revenue */


with cte1 as
(
select  dp.product_key,
        dp.product_name,
        dp.category,
        count(distinct customer_id) as total_customers,
        sum(sales_amount) as total_revenue
        from gold.fact_sales as fs
        left join gold.dim_products as dp
        on fs.product_key = dp.product_key
        left join gold.dim_customers as dc
        on fs.customer_key = dc.customer_key
        group by dp.product_key,
                 dp.product_name,
                 dp.category
                 )
                 , cte2 as
                 (  SELECT
                           dp.product_key,
                           dc.customer_id,
                           COUNT(DISTINCT DATEFROMPARTS(YEAR(order_date),MONTH(order_date), 1 )) AS purchase_months
                           FROM gold.fact_sales AS fs
                           LEFT JOIN gold.dim_products AS dp
                           ON fs.product_key = dp.product_key
                           LEFT JOIN gold.dim_customers AS dc
                           ON fs.customer_key = dc.customer_key
                           GROUP BY dp.product_key,dc.customer_id
                           )
                           , cte3 as
                           (select product_key,
                                   count(*) as repeat_customers
                                   from cte2
                                   where purchase_months >=2
                                   group by product_key
                                   )

                                   SELECT
                                         c1.product_key,
                                         c1.product_name,
                                         c1.category,
                                         c1.total_customers,
                                         c3.repeat_customers,
                                         ROUND(100.0 * c3.repeat_customers / c1.total_customers,2) AS repeat_customer_pct,
                                         c1.total_revenue
                                         FROM cte1 AS c1
                                         INNER JOIN cte3 AS c3
                                         ON c1.product_key = c3.product_key
                                         WHERE
                                         100.0 * c3.repeat_customers / c1.total_customers >= 2
                                         ORDER BY repeat_customer_pct DESC;
