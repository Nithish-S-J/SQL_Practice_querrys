/*For every customer, calculate:

First Purchase Month
Last Purchase Month
Active Months (distinct purchase months)
Total Revenue
Average Monthly Revenue

Return only customers who:

Were active in at least 6 distinct months
Have Average Monthly Revenue greater than the company average customer monthly revenue
Return
customer_id
customer_name
country
first_purchase_month
last_purchase_month
active_months
total_revenue
avg_monthly_revenue
company_avg_monthly_revenue*/

with cte1 as
(
select
      dc.customer_id,
      concat(dc.first_name,' ' ,dc.last_name) as customer_name,
      country,
      DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
      sum(sales_amount) as monthly_revenue
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      group by  dc.customer_id,
                concat(dc.first_name,' ' ,dc.last_name) ,
                country,
                DATEFROMPARTS(year(order_date),month(order_date),1)
                )
                , cte2 as
                (select customer_id,
                        customer_name,
                        country,
                        min(sales_month) as first_purchase_month,
                        max(sales_month) as last_purchase_month,
                        count(*) as active_months,
                        avg(monthly_revenue) as avg_monthly_revenue
                        from cte1
                        group by customer_id,
                                 customer_name,
                                 country
                                 
                        )
                        ,cte3 as
                        (select *,
                                avg(avg_monthly_revenue)over() as company_avg_monthly_revenue
                                from cte2
                                )
                                select * from cte3
                                where active_months >=6
                                and avg_monthly_revenue > company_avg_monthly_revenue
