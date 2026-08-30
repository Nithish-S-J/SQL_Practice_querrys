/*For every customer, find their first-ever calendar month of purchase and the revenue they generated in that month.

Return
customer_id
customer_name
country
first_purchase_month
first_month_revenue */

with cte1 as
(
select 
       dc.customer_id,
       dc.first_name as customer_name,
       dc.country,
       DATEFROMPARTS(year(order_date),month(order_date),1) as first_purchase_month,
       sum(sales_amount) as first_month_revenue
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.customer_id,
                dc.first_name,
                dc.country,
                DATEFROMPARTS(year(order_date),month(order_date),1)
                )
                , cte2 as
                (select *,
                        row_number()over(partition by customer_id order by first_purchase_month) as rn
                        from cte1
                        )
                        select *
                               from cte2
                               where rn = 1
