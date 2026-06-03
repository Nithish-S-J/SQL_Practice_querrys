--Find categories where the total sales of the Top 3 products exceed 
--the average Top 3 product sales total across all categories.

with cte1 as
(
select p.category,
       o.productid,
       sum(o.sales) as totalsales,
       dense_rank()over(partition by p.category order by sum(o.sales) desc) as rn
       from orders as o
       left join products as p
       on o.productid = p.productid
       group by p.category, o.productid
       )
       , cte2 as 
       ( 
        select category,
               sum(totalsales) as totalsales2
               from cte1
               where rn <=3
               group by category)
               select * from
               (
               select *,
                      avg(totalsales2)over() as avgtotalsales
                      from cte2)t
                      where totalsales2 > avgtotalsales




       

       
