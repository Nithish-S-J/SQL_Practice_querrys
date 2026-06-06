--Find countries where the average sales of the 
--Bottom 2 customers is less than the average sales of all customers in that country.

with cte1 as
(
select c.country,
       o.customerid,
       avg(o.sales) as avgsales,
       dense_rank()over(partition by country order by avg(o.sales) asc) as rn
       from orders as o
       left join [sales.customers] as c
       on o.customerid = c.id
       group by c.country, o.customerid)
       , cte2 as 
       ( select 
               country,
               avg(avgsales) as salesavg
               from cte1
               where rn <=2
               group by country)
               , cte3 as 
               ( select country,
                        avg(avgsales) as avgavgsales
                        from cte1
                        group by country)

                        select * from cte2 as c2
                        join cte3 as c3 
                        on c2.country = c3.country
                        where salesavg < avgavgsales
