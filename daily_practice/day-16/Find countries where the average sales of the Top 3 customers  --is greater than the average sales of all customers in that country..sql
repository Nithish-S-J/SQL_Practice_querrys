--Find countries where the average sales of the Top 3 customers 
--is greater than the average sales of all customers in that country.


with cte as
(
select  c.country,
        o.customerid,
        avg(o.sales) as avgsales,
        dense_rank()over(partition by country order by avg(o.sales) desc) as rn
        from orders as o
        left join [sales.customers] as c
        on o.customerid = c.id
        group by c.country,o.customerid
        )
        , cte2 as
        (
        select country,
               avg(avgsales) as top3avg
               from cte
               where rn <=3
               group by country)
              ,cte3 as 
              (select country,
                      avg(avgsales) avgsales
                      from cte
                      group by country)
                                            
                      select *
                      from cte2 as c2
                      join cte3 as c3
                      on c2.country = c3.country
                      where  avgsales < top3avg

              
