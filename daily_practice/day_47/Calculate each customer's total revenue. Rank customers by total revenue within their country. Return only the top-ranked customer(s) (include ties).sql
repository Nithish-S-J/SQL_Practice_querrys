/* For every country:

Calculate each customer's total revenue.
Rank customers by total revenue within their country.
Return only the top-ranked customer(s) (include ties).

Additionally calculate:
Customer Revenue
Country Revenue
Customer Contribution %
Revenue Rank

Return
country
customer_id
customer_name
customer_revenue
country_revenue
customer_contribution_pct
revenue_rank */

with cte1 as
(
select dc.country,
       dc.customer_id,
       concat(dc.first_name,' ',dc.last_name) as customer_name,
       sum(sales_amount) as total_sales,
       rank()over(partition by country order by sum(sales_amount) desc) as revenue_rank
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       left join gold.dim_products as dp 
       on fs.product_key = dp.product_key
       group by dc.country,
                dc.customer_id,
                concat(dc.first_name,' ',dc.last_name)
                )
             select country,
                    customer_id,
                    customer_name,
                    revenue_rank,
                    total_sales as customer_revenue,
                    sum(total_sales)over(partition by country) as country_revenue,
                    round(100.0* total_sales / sum(total_sales)over(partition by country),2) as contribution_pct
                    from cte1
                    where revenue_rank = 1
                    order by country,
                             total_sales desc
