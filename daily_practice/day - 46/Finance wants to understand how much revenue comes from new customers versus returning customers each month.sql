/* Finance wants to understand how much revenue comes from new customers versus returning customers each month.

Task

For every calendar month calculate:

Revenue from customers making their first-ever purchase
Revenue from returning customers
Total revenue

Return:

sales_month
new_customer_revenue
returning_customer_revenue
total_revenue
new_customer_pct
returning_customer_pct */

with first_purchase
as
(
select customer_key,
       DATEFROMPARTS(year(min(order_date)),month(min(order_date)),1) as first_purchase_month
       from gold.fact_sales as fs
       group by customer_key
       )
       , sales_classified as
       (select DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
               fs.sales_amount,
               fp.first_purchase_month
               from gold.fact_sales as fs
               join first_purchase as fp
               on fs.customer_key = fp.customer_key
               )

               select 
                      sales_month,
                      sum(case 
                              when sales_month <>first_purchase_month
                              then sales_amount
                              else 0 
                              end) as returning_customer_revenue,

                              sum(sales_amount) as total_sales,

                              round(100.0* sum(case when sales_month = first_purchase_month
                                         then sales_amount
                                         else 0
                                         end)
                                         /
                                         sum(sales_amount),2) as new_customer_pct,

                                         round(100.0*sum(case 
                                                            when sales_month <>first_purchase_month
                                                            then sales_amount
                                                            else 0 
                                                            end)
                                                            /
                                                            sum(sales_amount),2) as returning_customer_pct

                                                            from sales_classified 
                                                            group by sales_month
                                                            order by sales_month

