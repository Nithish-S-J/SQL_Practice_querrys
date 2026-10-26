/* Sales leadership wants to know when customers first became significant contributors.

For each customer, calculate their monthly revenue and rank them within their country for that month.

Find the first calendar month in which each customer achieved a Top-10 revenue position within their country.

Return
customer_id
customer_name
country
first_top10_month
monthly_revenue
revenue_rank */

with cte1 as
(
select  dc.customer_id,
        dc.first_name as customer_name,
        dc.country,
        DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
        sum(sales_amount) as monthly_revenue
        from gold.fact_sales as fs
        left join gold.dim_customers as dc
        on fs.customer_key = dc.customer_key
        group by  dc.customer_id,
                  dc.first_name,
                  dc.country,
                  DATEFROMPARTS(year(order_date),month(order_date),1) 
                  )
                  , cte2 as
                  (select *,
                          dense_rank()over(partition by country, sales_month order by monthly_revenue desc) as revenue_rank
                          from cte1)
                          , cte3 as
                          (select *,
                                  min(sales_month)over(partition by customer_id order by monthly_revenue desc) as first_top10_month
                                  from cte2
                                  where revenue_rank <=10
                                  )

                                  select 
                                  customer_id,
customer_name,
country,
first_top10_month,
monthly_revenue,
revenue_rank
from cte3
where sales_month = first_top10_month
order by country, first_top10_month
