/* A customer is considered high-value if:
They purchased products from at least 3 different categories, and
Their total revenue is greater than the average customer revenue across the entire company.
Return
customer_id
customer_name
country
categories_purchased
total_revenue
company_avg_customer_revenue
revenue_above_average
Where:
revenue_above_average
=
total_revenue
-
company_avg_customer_revenue */

with cte1 as
(
select
      dc.customer_id,
      dc.country,
      concat(dc.first_name,' ', dc.last_name) as customer_name,
      count(distinct dp.category) as categories_purchased,
      sum(sales_amount) as total_revenue
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      group by dc.customer_id,
               concat(dc.first_name,' ', dc.last_name),
               dc.country
               )
               , cte2 as
               (select *,
                       avg(total_revenue)over() as avg_customer_revenue
                       from cte1
                       )

                       select customer_id,
                              customer_name,
                              country,
                              categories_purchased,
                              total_revenue,
                              avg_customer_revenue,
                              total_revenue - avg_customer_revenue as revenue_above_avg
                              from cte2
                              where categories_purchased >=3
                              and total_revenue > avg_customer_revenue


               
           
