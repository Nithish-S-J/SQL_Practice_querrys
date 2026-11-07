/* For every calendar month, 
calculate: Revenue from customers purchasing in their first-ever purchase month 
Revenue from returning customers 
Total monthly revenue 
New customer revenue % 
Returning customer revenue % 
Return -- sales_month, new_customer_revenue ,returning_customer_revenue, total_revenue, new_customer_pct, returning_customer_pct */

with cte1 as
(
select 
       customer_key,
       DATEFROMPARTS(year(min(order_Date)),month(min(order_date)),1) as first_purchase_month
       from gold.fact_sales as fs
       group by customer_key
       )
       , cte2 as
       (select 
               DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,

               sum(case when DATEFROMPARTS(year(order_date),month(order_date),1) = c1.first_purchase_month 
                        then fs.sales_amount
                        else 0
                        end ) as new_customer_revenue ,

                        sum(case when DATEFROMPARTS(year(order_date),month(order_date),1) > c1.first_purchase_month 
                        then fs.sales_amount 
                        else 0 
                        end ) as returning_customer_revenue,

                        sum(fs.sales_amount) as total_revenue

                        from gold.fact_sales as fs
                        inner join cte1 as c1
                        on fs.customer_key = c1.customer_key
                        group by
               DATEFROMPARTS(year(order_date),month(order_date),1)
               )
               select 
                      sales_month, 
                      new_customer_revenue ,
                      returning_customer_revenue, 
                      total_revenue,

                      round(100.0* new_customer_revenue / total_revenue,2) as new_cust_pct,

                      round (100.0* returning_customer_revenue / total_revenue,2) as returning_customer_revenue_pct

                      from cte2
                      order by sales_month desc
