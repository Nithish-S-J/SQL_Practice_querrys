
/* For every country calculate - Total Revenue, Distinct Customers, Average Revenue Per Customer, 
Revenue Rank,Customer Rank, 
Finally calculate - Performance Score = Revenue Rank + Customer Rank
Return = country, total_revenue, customers, avg_revenue_per_customer, 
revenue_rank, customer_rank,
performance_score
Sort by = performance_score ASC
If two countries have the same score,
sort by = total_revenue DESC */


select dc.country, 
       sum(sales_amount) as total_sales,
       count(distinct customer_id) as customers,
       sum(sales_amount) * 1.0 /  count(distinct customer_id) as avg_revenue_per_customer,
       rank()over(order by sum(sales_amount)) as revenue_rank,
       rank()over(order by count(distinct customer_id)) as customer_rank,
       rank()over(order by sum(sales_amount)) + rank()over(order by count(distinct customer_id)) as performance_score
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country
       order by sum(sales_amount) desc
