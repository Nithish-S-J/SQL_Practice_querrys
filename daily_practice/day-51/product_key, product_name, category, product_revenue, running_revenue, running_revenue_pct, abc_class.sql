/*Management wants to classify products using ABC Analysis.
Rules: Products are sorted by revenue (highest to lowest). 
Classification: Running Revenue % ≤ 80% → A 80–95% → B >95% → C 
Return -- product_key, product_name, category, product_revenue, running_revenue, running_revenue_pct, abc_class */

with cte1 as
(
select
       dp.product_key,
       dp.product_name,
       dp.category,
       
       sum(sales_amount) as product_revenue
      from gold.fact_sales as fs
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      group by dp.product_key,
       dp.product_name,
       dp.category
    
       )
       , cte2 as
       (select *,
               sum(product_revenue)over(order by product_revenue, product_key desc) as running_revenue,
               
               round(100.0*sum(product_revenue)over(order by product_revenue, product_key)
               /
               sum(product_revenue)over(),2) as running_revenue_pct

               from cte1
               )
               
               select 
                      product_key,
                      product_name,
                      product_revenue,
                      category,
                      running_revenue,
                      running_revenue_pct,

                      case when running_revenue_pct  < = 80  then ' A '
                           when running_revenue_pct > 80 and running_revenue_pct < 90 then ' B '
                           when running_revenue_pct  > 90       then ' C '
                           else 'other_type'
                           end as ABC_class
                      from cte2
