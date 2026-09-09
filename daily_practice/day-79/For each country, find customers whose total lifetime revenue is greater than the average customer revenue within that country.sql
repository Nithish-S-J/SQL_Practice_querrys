/*For each country, find customers whose total lifetime revenue is greater than the average customer revenue within that country.

Return:

country
customer_id
customer_name
total_revenue
country_avg_revenue
revenue_difference */

with cte1 as
(
select dc.country,
       dc.customer_id,
       dc.first_name as customer_name,
       sum(sales_amount) as total_revenue
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by dc.country,
                dc.customer_id,
                dc.first_name
                ), cte2 as
                (select country,
                        avg(total_revenue) as country_avg_revenue
                        from cte1
                        group by country
                        )
                        select *,
                               total_revenue - country_avg_revenue as revenue_difrnce
                               from cte1 as c1
                        left join cte2 as c2
                        on c1.country = c2.country
                        where total_revenue > country_avg_revenue
