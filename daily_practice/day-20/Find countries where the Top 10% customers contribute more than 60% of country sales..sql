---Find countries where the Top 10% customers contribute more than 60% of country sales.

with cte1 as
(
select dc.country,
       fs.customer_key,
       sum(fs.sales_amount) as totalsales,
       percent_rank()over(partition by dc.country order by sum(fs.sales_amount)desc) as pctrank
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country,fs.customer_key)
       , cte2 as 
       ( select country,
              sum( case when pctrank <=0.10 then totalsales end) as top10sales
             from cte1
             group by country)
             , cte3 as
             (select country, 
                     sum(totalsales) as countrysales
                     from cte1
                     group by country)

                     select *,
                            round(100.0*(top10sales/countrysales),2) as pctsales
                            from cte2 as c2
                            join cte3 as c3
                            on c2.country = c3.country
                            where top10sales > 0.60*countrysales
