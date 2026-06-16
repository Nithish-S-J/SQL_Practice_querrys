----Find countries where the combined sales of the Top 5 customers are greater than the 
---combined sales of the Top 3 products in the same country.

with customersales as
(
select 
       dc.country,
       fs.customer_key,
       sum(fs.sales_amount) as totalsales,
       dense_rank()over(partition by country order by sum(fs.sales_amount)desc) as top5       
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country, fs.customer_key
       )
       , cte1 as 
       ( select country,
                sum(totalsales) as top5customersales
                from customersales
                where top5<=5
                group by country)
                 ,productsales as
                 (select dc.country,
                         fs.product_key,
                         sum(fs.sales_amount) as totalsales,
                         DENSE_RANK()over(partition by country order by sum(fs.sales_amount)desc) as top3
                         from gold.fact_sales as fs
                         left join gold.dim_customers as dc
                         on fs.customer_key = dc.customer_key
                         group by dc.country,fs.product_key)
                         , cte2 as 
                         (select country,
                                 sum(totalsales) as top3productsales
                                 from productsales 
                                 where top3<=3
                                 group by country)

                                 select * from cte1 as c1
                                 join cte2 as c2
                                 on c1.country = c2.country
                                 where top5customersales > top3productsales      












