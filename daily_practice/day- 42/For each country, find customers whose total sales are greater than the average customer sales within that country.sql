/* For each country, find customers whose total sales are greater than the average customer sales within that country.
Return:
country
customer_id
customer_name
total_sales
country_avg_sales
sales_difference */

with cte1 as
(
select dc.country,
       dc.customer_id,
       concat(dc.first_name, ' ',dc.last_name) as customer_name,
       sum(sales_amount) as total_sales
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by country, customer_id, concat(dc.first_name, ' ',dc.last_name)
       )
       , cte2 as
       (select country,
               avg(total_sales) as avg_country_sales
               from cte1
               group by country
               )
              
              select
              c1.country,
              customer_id,
              customer_name,
              total_sales,
              avg_country_sales,
              total_sales - avg_country_sales as sales_difference
              from cte1 as c1
              join cte2 as c2
              on c1.country = c2.country
              where total_sales > avg_country_sales
               
