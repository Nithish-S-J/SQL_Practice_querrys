/*For every product and calendar month, calculate:

Monthly Revenue
3-Month Rolling Revenue
3-Month Rolling Average Revenue
Revenue Growth compared to the previous month

Return:

product_key
product_name
category
sales_month
monthly_revenue
rolling_3_month_revenue
rolling_3_month_avg
previous_month_revenue
growth_pct */

with cte1 as
(
select 
      dp.product_key,
      dp.product_name,
      dp.category,
      DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
      sum(sales_amount) as monthly_revenue
      from gold.fact_sales as fs
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      group by dp.product_key,
      dp.product_name,
      dp.category,
      DATEFROMPARTS(year(order_date),month(order_date),1)
      )

      select *,
              sum(monthly_revenue)over(partition by product_key order by sales_month
                                           rows between 2 preceding and current row) as rolling_3_month_revenue,

                                          avg(monthly_revenue)over(partition by product_key order by sales_month
                                           rows between 2 preceding and current row) as rolling_3_month_avg,

                                           lag(monthly_revenue)over(partition by product_key order by sales_month) as previous_month_sales,

                                           monthly_revenue- lag(monthly_revenue)over(partition by product_key order by sales_month) as revenue_growth,

                                           round(100.0*(monthly_revenue - lag(monthly_revenue)over(partition by product_key order by sales_month))
                                           /
                                           lag(monthly_revenue)over(partition by product_key order by sales_month),2) as growth_pct

                                           from cte1
