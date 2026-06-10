--Find countries where the combined sales of the Top 3 customers contribute 
---more than 50% of the country's total customer sales.

with cte1 as
(
select dc.country,
       fs.customer_key,
       sum(fs.sales_amount) as totalsales,
       dense_rank()over(partition by dc.country order by sum(fs.sales_amount) desc) as rn
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country,fs.customer_key)
       , cte2 as
       (select country,
               sum(totalsales) as totallsalestop3
               from cte1
               where rn <=3
               group by country)
               , cte3 as
               (select country,
                       sum(totalsales) as totallsalesswhole
                       from cte1
                       group by country)

                       select c2.country,
                              c2.totallsalestop3,
                              c3.totallsalesswhole,
                              round (100.0 *c2.totallsalestop3/c3.totallsalesswhole,2) as contripct
                              from cte2 as c2
                              join cte3 as c3
                              on c2.country = c3.country
                              
