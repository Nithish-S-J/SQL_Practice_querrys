/* customer_id
customer_name
first_purchase_month
second_purchase_month
third_purchase_month
fourth_purchase_month */

with cte1 as
(
select distinct
       dc.customer_id,
       dc.first_name as customer_name,
       DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       )
       , cte2 as
       (select *,
              row_number()over(partition by customer_id order by sales_month) as rn
              from cte1
              )

       select customer_id,
              customer_name,
               max(case when rn = 1 then sales_month end) as first_purchase_month,
               max(case when rn = 2 then sales_month end) as second_purchase_month,
               max(case when rn = 3 then sales_month end) as third_purchase_month,
               max(case when rn = 4 then sales_month end) as fourth_purchase_month
               from cte2
               group by customer_id,
              customer_name
               
