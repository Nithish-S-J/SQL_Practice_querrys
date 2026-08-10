/* Management wants to compare product category performance.
For every calendar month calculate:
Return
sales_month
category
category_revenue
company_month_revenue
market_share_pct
previous_market_share_pct
market_share_change */

with cte1 as
(
select category,
       DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
       sum(sales_amount) as category_revenue
       from gold.fact_sales as fs
       left join gold.dim_products as dp 
       on fs.product_key = dp.product_key
       group by category,
                DATEFROMPARTS(year(order_date),month(order_date),1)
                )
                , cte2 as 
                (select *,
                        sum(category_revenue)over(partition by  sales_month) as company_month_revenue,

                        round(100.0*(category_revenue 
                        / 
                        sum(category_revenue)over(partition by  sales_month)),2) as company_share_pct
                        from cte1
                        )

                       select *,
                                lag(company_share_pct)over(partition by category order by sales_month) as previous_market_share_pct,

                                company_share_pct - lag(company_share_pct)over(partition by category order by sales_month) as market_share_change
                                
                                from cte2
                             
