---Find countries where the Top 5 customers 
---contribute more sales than the Top 5 products contribute within the same country.


with customer_sales as
(
select dc.country,
       fs.customer_key,      
       sum(fs.sales_amount) as totalsales,
       dense_rank()over(partition by country order by sum(fs.sales_amount)desc) as top5customer
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country,fs.customer_key
       )
       , cte1 as 
       (select country,
               sum(totalsales) as top5customersale
               from customer_sales
               where top5customer<=5
               group by country)
               , product_sales as
               (select dc.country,
                       fs.product_key,
                       sum(fs.sales_amount) as totalsales,
                       DENSE_RANK()over(partition by country order by sum(fs.sales_amount)desc) as top5product
                       from gold.fact_sales as fs
                       left join gold.dim_products as dp
                       on fs.product_key = dp.product_key
                       left join gold.dim_customers as dc
                       on fs.customer_key=dc.customer_key
                       group by dc.country,fs.product_key
                       )
                       , cte2 as 
                       (select country,
                               sum(totalsales) as top5productsale
                               from product_sales
                               where top5product<=5
                               group by country)

                               select * from cte1 as c1
                               join cte2 as c2
                               on c1.country = c2.country
                               where top5customersale<top5productsale
