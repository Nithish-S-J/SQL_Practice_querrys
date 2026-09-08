/* Find each customer's first-ever purchase month and the total revenue they generated during that month.

Return:

customer_id
customer_name
country
first_purchase_month
first_month_revenue */

with cte1 as
(
select dc.customer_id,
       dc.first_name as customer_name,
       dc.country,
       DATEFROMPARTS(year(order_date),month(order_date),1) as first_purchase_month,
       sum(sales_amount) as first_month_revenue,
       row_number()over(partition by customer_id order by DATEFROMPARTS(year(order_date),month(order_date),1)) as rn
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group  by dc.customer_id,
                 dc.first_name,
                 dc.country,
                 DATEFROMPARTS(year(order_date),month(order_date),1)
                 )
                
                         select * from cte1
                         where rn = 1
