--  Find the customers that contribute to the first 80% of total company revenue,

with cte1 as
(
select 
      dc.customer_key,
      concat(dc.first_name,' ',dc.last_name) as customer_name,
      sum(sales_amount) as total_sales
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      group by dc.customer_key, concat(dc.first_name,' ',dc.last_name)
      )
      select * from 
      (select *,
              sum(total_sales)over() as customer_sales,
              sum(total_sales)over(order by total_sales desc) as running_sales,

              round(100.0*total_sales
              /
              sum(total_sales)over(),2) as contribution_pct,

              round(100.0* sum(total_sales)over(order by total_sales desc)
              /
              sum(total_sales)over(),2) as cumulative_pct
              
              from cte1)t
               
               where cumulative_pct <=80
