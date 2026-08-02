/* For every calendar month, calculate:

Revenue from customers purchasing in their first-ever purchase month
Revenue from returning customers
Total monthly revenue
New customer revenue %
Returning customer revenue %
Return --
sales_month
new_customer_revenue
returning_customer_revenue
total_revenue
new_customer_pct
returning_customer_pct
*/

with first_purchase as
(
select 
       customer_key,
       DATEFROMPARTS(year(min(order_date)),month(min(order_date)),1) as first_purchase_month
       from gold.fact_sales        
       group by customer_key
       )
       , cte2 as
       (select 
               
               DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,

                 SUM( CASE
                           WHEN DATEFROMPARTS( YEAR(fs.order_date), MONTH(fs.order_date), 1) = fp.first_purchase_month
                      THEN fs.sales_amount
                      ELSE 0
            END
        ) AS new_customer_revenue,

        SUM(
            CASE
                WHEN DATEFROMPARTS(
                        YEAR(fs.order_date),
                        MONTH(fs.order_date),
                        1
                     ) > fp.first_purchase_month
                THEN fs.sales_amount
                ELSE 0
            END
        ) AS returning_customer_revenue,
         SUM(fs.sales_amount) AS total_revenue
                
             FROM gold.fact_sales AS fs
             INNER JOIN first_purchase AS fp
             ON fs.customer_key = fp.customer_key
             group by DATEFROMPARTS(year(order_date),month(order_date),1) 
             )

 SELECT
    sales_month,
    new_customer_revenue,
    returning_customer_revenue,
    total_revenue,

    ROUND(
        100.0 * new_customer_revenue
        / NULLIF(total_revenue, 0),
        2
    ) AS new_customer_pct,

    ROUND(
        100.0 * returning_customer_revenue
        / NULLIF(total_revenue, 0),
        2
    ) AS returning_customer_pct

FROM cte2
ORDER BY sales_month;
