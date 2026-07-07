---Calculate total sales per customer and return customers whose revenue is the third highest distinct total sales value in their country.
---Return:,country, customer_id, customer_name, total_sales, revenue_position

with cte1 as
(
select 
      dc.country,
      dc.customer_id,
      concat(dc.first_name,' ',dc.last_name) as customer_name,
      sum(sales_amount) as total_sales,
      dense_rank()over(partition by country order by sum(sales_amount) desc) as revenue_position
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      group by dc.country,dc.customer_id,concat(dc.first_name,' ',dc.last_name)
      )
      select * from cte1
      where revenue_position = 3
