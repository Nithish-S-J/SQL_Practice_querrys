/* For each country calculate:

Total Revenue
Total Orders
Distinct Customers
Distinct Products
Average Order Value
Average Revenue Per Customer
Top Customer Contribution %
Revenue Rank
Customer Rank
Order Rank

Finally calculate:
Executive Score
=
Revenue Rank
+
Customer Rank
+
Order Rank
*/

with customer_sales as
(
select
       dc.country,
       dc.customer_id,
       sum(fs.sales_amount) as customer_revenue
from gold.fact_sales as fs
left join gold.dim_customers as dc
on fs.customer_key = dc.customer_key
group by
       dc.country,
       dc.customer_id
)

, cte1 as
(
select
       dc.country,

       sum(fs.sales_amount) as total_revenue,
       count(distinct fs.order_number) as orders,
       count(distinct dc.customer_id) as distinct_customers,
       count(distinct dp.product_id) as distinct_products,

       round(
       sum(fs.sales_amount)*1.0
       /
       count(distinct fs.order_number),2
       ) as avg_order_value,

       round(
       sum(fs.sales_amount)*1.0
       /
       count(distinct dc.customer_id),2
       ) as avg_revenue_per_customer

from gold.fact_sales as fs

left join gold.dim_customers as dc
on fs.customer_key = dc.customer_key

left join gold.dim_products as dp
on fs.product_key = dp.product_key

group by
       dc.country
)

, cte2 as
(
select
       country,
       max(customer_revenue) as top_customer_revenue
from customer_sales
group by country
)

, cte3 as
(
select
       c1.country,
       c1.total_revenue,
       c1.orders,
       c1.distinct_customers,
       c1.distinct_products,
       c1.avg_order_value,
       c1.avg_revenue_per_customer,

       c2.top_customer_revenue,

       round
       (
       100.0*c2.top_customer_revenue
       /
       c1.total_revenue,
       2
       ) as top_customer_pct

from cte1 as c1

join cte2 as c2
on c1.country=c2.country
)

select
       country,
       total_revenue,
       orders,
       distinct_customers as customers,
       distinct_products as products,
       avg_order_value,
       avg_revenue_per_customer,
       top_customer_pct,

       rank() over(order by total_revenue desc) as revenue_rank,

       rank() over(order by distinct_customers desc) as customer_rank,

       rank() over(order by orders desc) as order_rank,

       rank() over(order by total_revenue desc)
       +
       rank() over(order by distinct_customers desc)
       +
       rank() over(order by orders desc)
       as executive_score

from cte3

order by executive_score 
