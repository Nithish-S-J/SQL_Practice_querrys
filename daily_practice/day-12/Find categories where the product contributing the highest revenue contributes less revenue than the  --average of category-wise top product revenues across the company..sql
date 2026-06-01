--Find categories where the product contributing the highest revenue contributes less revenue than the 
--average of category-wise top product revenues across the company.

with cte1 as

(
select p.category,
       o.productid,
       sum(o.sales) as totalsales
       from orders as o
       left join products as p
       on o.productid = p.productid
       group by p.category,o.productid
       )

       , cte2 as

       (
       select category,
              max(totalsales) as highestsales
              from cte1 
              group by category )

              select * from 

              (
              select *,
                     avg(highestsales)over() as avrghighsales
                     from cte2)t
                     where highestsales < avrghighsales

