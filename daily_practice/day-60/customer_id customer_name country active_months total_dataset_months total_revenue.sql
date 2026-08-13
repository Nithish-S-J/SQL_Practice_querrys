/*Find customers who made at least one purchase in every distinct calendar month available in the entire sales dataset.

Return
customer_id
customer_name
country
active_months
total_dataset_months
total_revenue */

with cte1 as
(
select 
         dc.customer_id,
         dc.first_name as customer_name,
         dc.country,
         
         count(distinct DATEFROMPARTS(year(order_date),month(order_date),1)) as active_months,
         sum(sales_amount) as total_revenue
         from gold.fact_sales as fs
         left join gold.dim_customers as dc
         on fs.customer_key = dc.customer_key
         group by  dc.customer_id,
         dc.first_name ,
         dc.country
         )
         , cte2 as
         (select          
         count(distinct DATEFROMPARTS(year(order_date),month(order_date),1)) as total_dataset_months
         from gold.fact_sales 
         )
        
       SELECT
    c1.customer_id,
    c1.customer_name,
    c1.country,
    c1.active_months,
    c2.total_dataset_months,
    c1.total_revenue

FROM cte1 AS c1
CROSS JOIN cte2 AS c2

WHERE c1.active_months = c2.total_dataset_months

ORDER BY c1.customer_id;
