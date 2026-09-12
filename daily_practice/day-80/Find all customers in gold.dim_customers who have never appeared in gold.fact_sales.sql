/*Find all customers in gold.dim_customers who have never appeared in gold.fact_sales.

Return:

customer_id
customer_name
country */

select dc.customer_id,
       dc.first_name as customer_name,
       dc.country
       from gold.dim_customers as dc
left join gold.fact_sales as fs
on dc.customer_key = fs.customer_key
where fs.customer_key is null
