--Find countries where the Top 3 categories contribute more than 50% of total country sales.

with cte1 as
(
select dc.country,
       dp.category,
       sum(fs.sales_amount) as totalsales,
       dense_rank()over(partition by country order by sum(sales_amount) desc) as rn
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country, dp.category)
       , cte2 as 
       (select country,
               
               sum(totalsales) as top3sales
               from cte1
               where rn<=3
               group by country)
               , cte3 as 
               (select country,
                       sum(totalsales) as countrysales
                       from cte1
                       group by country)
                      
                      select *,
                             round(100.0*top3sales/countrysales,2) as pctrank
                             from cte2 as c2
                             join cte3 as c3
                             on c2.country = c3.country
                             where top3sales > 0.50*countrysales
