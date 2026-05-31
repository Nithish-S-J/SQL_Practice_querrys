--Find product categories where the average product sales are higher than the overall average of 
---category average sales.


with cte as 
(
select
p.category,
avg(o.sales) as avgsales
from orders as o
left join products as p
on o.productid = p.productid
group by  p.category
)
select * from
(
select 
      category,
      avgsales,
      avg(avgsales)over() as overallavrg
      from cte)t
      where  avgsales > overallavrg


       
