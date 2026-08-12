/*Finance wants to identify customers who collectively generate the first 80% of company revenue.

customer_id
customer_name
country
customer_revenue
revenue_contribution_pct
running_revenue
running_revenue_pct
revenue_class */


with cte1 as
(
select 
       dc.customer_id,
       dc.first_name as customer_name,
       dc.country,
       sum(sales_amount) as customer_revenue
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by   dc.customer_id,
                  dc.first_name,
                  dc.country
                  )
                  , cte2 as
                  (select *,
                          sum(customer_revenue)over( order by customer_revenue desc) as running_revenue,
                          round(100.0*customer_revenue / sum(customer_revenue)over(),2) as revenue_contribution_pct,
                          round(100.0*sum(customer_revenue)over( order by customer_revenue desc)
                          /
                          sum(customer_revenue)over(),2) as running_revenue_pct


                          from cte1)
                          , cte3 as
                          (select *,
                                  case when running_revenue_pct <=80 then 'A'
                                          else 'B'
                                          end  as revenue_class
                                          from cte2
                                          )
                                          select customer_id,
customer_name,
country,
customer_revenue,
revenue_contribution_pct,
running_revenue,
running_revenue_pct,
revenue_class
from cte3

