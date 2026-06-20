---Find months where sales increased compared
---to the previous month
with cte1 as 
(
select 
       format(order_date,'yyyy-mm') as month,
       sum(sales_amount) as total_sales
       from gold.fact_sales as fs
       group by format(order_date,'yyyy-mm')
       )
       , prev_sales as
       (select*,
               lag(total_sales)over(order by month) as previousmonth_sales
               from cte1
               )
               select * from 
               prev_sales
               where total_sales > previousmonth_sales
