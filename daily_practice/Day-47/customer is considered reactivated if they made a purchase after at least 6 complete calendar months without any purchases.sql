/*A customer is considered reactivated if they made a purchase after at least 6 complete calendar months without any purchases.

Return
customer_id
customer_name
country
previous_purchase_month
reactivation_month
inactive_months
reactivation_revenue */

with cte1 as
(
select dc.customer_id,
       dc.country,
       concat(dc.first_name, ' ', dc.last_name) as customer_name,
       DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
       sum(sales_amount) as reactivation_revenue
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      group by dc.customer_id,
       dc.country,
       concat(dc.first_name, ' ', dc.last_name),
       DATEFROMPARTS(year(order_date),month(order_date),1)
      )
      , cte2 as
      (select *,
              lag(sales_month)over(partition by customer_id order by sales_month) as previous_purchase_month
              from cte1
              )
              , month_gap as
              (select *,
                       DATEDIFF(month, previous_purchase_month, sales_month) - 1 as inactive_month
                       from cte2
                       )

                    select customer_id,
                           customer_name,
                           country,
                           previous_purchase_month,
                           reactivation_revenue,
                           inactive_month,
                           sales_month as reactivation_month
                            from month_gap
                            where inactive_month >=6
