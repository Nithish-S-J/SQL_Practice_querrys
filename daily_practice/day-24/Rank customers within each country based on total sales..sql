---Rank customers within each country based on total sales.
-----country , customer_name, total_sales, sales_rank

with cte1 as
(
select dc.country,
       dc.first_name,
       dc.customer_key,
       sum(sales_amount) as total_sales,
       rank()over(partition by dc.country order by sum(sales_amount)desc) as sales_rank
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country,dc.first_name, dc.customer_key
       )

       select country,
              first_name as customer_name,
              total_sales,
              sales_rank
              from cte1
              where sales_rank<=3
