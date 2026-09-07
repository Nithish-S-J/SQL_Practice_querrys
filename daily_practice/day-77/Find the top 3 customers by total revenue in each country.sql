/*Find the top 3 customers by total revenue in each country.

Return:

country
customer_id
customer_name
total_revenue
revenue_rank
*/

with cte1 as
(
select dc.country,
       dc.customer_id,
       dc.first_name as customer_name,
       sum(sales_amount) as total_revenue,
       dense_rank()over(partition by dc.country order by sum(sales_amount) desc) as rn
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country,
                dc.customer_id,
                dc.first_name
       )
       select * from cte1
       where rn <=3
