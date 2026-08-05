/* For every country, find customers whose total revenue 
is the third-highest distinct customer revenue value in that country.

Return
country
customer_id
customer_name
total_revenue
revenue_rank */


with cte1 as
(
select 
       country,
       dc.customer_id,
       dc.first_name,
       sum(sales_amount) as total_sales,
       DENSE_RANK()over(partition by country order by sum(sales_amount) desc) as rn
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by country,
                dc.customer_id,
                dc.first_name
                )
                
                select *
                         from cte1
                         where rn = 3

                         
