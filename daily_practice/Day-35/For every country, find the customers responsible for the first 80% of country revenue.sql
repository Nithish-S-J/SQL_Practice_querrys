----For every country, find the customers responsible for the first 80% of country revenue.
--- Return country  customer_name,  total_sales, contribution_pct, cumulative_pct

with cte1 as
(
select 
       dc.country,
       concat(dc.first_name,' ', dc.last_name) as customer_name,      
       sum(sales_amount) as total_sales
      from gold.fact_sales as fs
      left join gold.dim_customers dc
      on fs.customer_key = dc.customer_key
      group by dc.country,concat(dc.first_name,' ', dc.last_name) 
      )
      , cte2 as 
      ( select *,
               sum(total_sales)over(partition by country) as country_sales,
               sum(total_sales)over(partition by country order by total_sales desc) as running_sales
               from cte1
               )
               , cte3 as 
               (
               select *,
                      round(100.0*(total_sales)/nullif((country_sales),0),2) as contribution_pct,
                      round(100.0*(running_sales)/nullif((country_sales),0),2) as cumulative_pct
                      from cte2)
                      select * from cte3
                      where cumulative_pct<=80
