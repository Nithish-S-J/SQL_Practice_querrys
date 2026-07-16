/* Find products that have been purchased by customers from every country present in the dataset.
Return:
product_key
product_name
countries_purchased
total_countries */


with cte1 as
(
select dp.product_key,
       dp.product_name,
       count(distinct country) as countries_purchased,
       (select count(distinct country)
                    from gold.dim_customers
                    where country is not null) as total_countries
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dp.product_key,dp.product_name
       )

       select * from cte1
       where countries_purchased = total_countries
    
