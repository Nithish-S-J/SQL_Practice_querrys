/* Management wants to divide customers into four revenue segments based on lifetime revenue.

Calculate total revenue for every customer and assign them to four buckets:

1 → Highest-revenue customer group
2 → Second group
3 → Third group
4 → Lowest-revenue customer group
Return
customer_id
customer_name
country
total_revenue
revenue_quartile */


with cte1 as
(
select 
       dc.customer_id,
       dc.first_name,
       country,
       sum(sales_amount) as total_revenue
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.customer_id,
       dc.first_name,
       country
       )
      select *,
               ntile(4)over(order by total_revenue desc) as buckets
               from cte1
               
