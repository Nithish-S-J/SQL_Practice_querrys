---Find the highest revenue generating customer in each country.

with cte1 as 
(
select  dc.country,
        dc.first_name,
        dc.last_name,
        fs.customer_key,
        sum(fs.sales_amount) as totalsales,
        DENSE_RANK()over(partition by country order by sum(fs.sales_amount) desc) as rank
        from gold.fact_sales as fs
        left join gold.dim_customers as dc
        on fs.customer_key = dc.customer_key
        group by dc.country,fs.customer_key,dc.first_name,dc.last_name
        )
               select 
                      country,
                      first_name,
                      last_name,
                      customer_key,
                      totalsales,
                      rank
                      from cte1
                      where rank<=1
