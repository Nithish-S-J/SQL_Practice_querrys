/*For each country, find the top 3 customers by total sales.

Return
country
customer_id
customer_name
total_sales
revenue_rank */

with cte1 as
(
select dc.country,
       dc.customer_id,
       dc.first_name as customer_name,
       sum(sales_amount) as total_sales,
       dense_rank()over(partition by country order by sum(sales_amount) desc) as rn
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country,
                dc.customer_id,
                dc.first_name
                )
                select * from cte1
                where rn <=3
