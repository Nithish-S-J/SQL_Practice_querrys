/*For every country, return the month that generated the highest revenue.

Return:

country
sales_month
monthly_sales*/

with cte1 as
(
select
      country,
      DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
      sum(sales_amount) as monthly_sales,
      rank()over(partition by country order by sum(sales_amount) desc) as rn
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      group by country, DATEFROMPARTS(year(order_date),month(order_date),1)
      )
      select * from cte1
      where rn = 1 
