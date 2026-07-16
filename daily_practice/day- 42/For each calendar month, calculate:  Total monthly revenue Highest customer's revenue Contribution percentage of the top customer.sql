/* For each calendar month, calculate:

Total monthly revenue
Highest customer's revenue
Contribution percentage of the top customer

Return:

sales_month
monthly_revenue
top_customer_revenue
top_customer_pct */

with cte1 as
(
select
      DATEFROMPARTS(year(order_date), month(order_date),1) as sales_month,
      dc.customer_id,
      sum(sales_amount) as customer_revenue
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      group by DATEFROMPARTS(year(order_date), month(order_date),1), dc.customer_id
      )
      , cte2 as
      (select sales_month,
              sum(customer_revenue) as monthly_revenue,
              max(customer_revenue) as top_customer_revenue
              from cte1
              group by sales_month
              )

              select *,
                     ROUND(100.0*top_customer_revenue / monthly_revenue ,2) as contribution_pct
                     from cte2
                     order by sales_month
