/* Find all customers from gold.dim_customers who have never made a purchase in gold.fact_sales.

Return
customer_id
customer_name
country */

select dc.customer_id,
       fs.customer_key,
       dc.first_name as customer_name,
       dc.country
       from gold.dim_customers as dc
       left join gold.fact_sales as fs
       on dc.customer_key = fs.customer_key
       where fs.customer_key is null
