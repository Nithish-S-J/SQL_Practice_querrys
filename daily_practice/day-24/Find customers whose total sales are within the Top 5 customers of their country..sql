---Find customers whose total sales are within the Top 5 customers of their country.
---country
---customer_key
--customer_name
--total_sales
---country_rank

with cte1 as
(
select  dc.country,
        concat(dc.first_name,' ',dc.last_name) as customer_name,
        fs.customer_key,
        sum(fs.sales_amount) as total_sales,
        DENSE_RANK()over(partition by dc.country order by sum(fs.sales_amount)desc) as country_rank
        from gold.fact_sales as fs
        left join gold.dim_customers as dc
        on fs.customer_key = dc.customer_key
        group by dc.country,concat(dc.first_name,' ',dc.last_name),fs.customer_key
        )
         
          select country,
                 customer_name,
                 customer_key,
                 total_sales,
                 country_rank
                 from cte1
                 where country_rank <=5
