---For each category and month: Calculate monthly sales, Show previous month's sales, Calculate growth %
--turn only months where growth exceeded 20%.

with cte1 as
(
select 
        dp.category,
        DATEFROMPARTS(year(order_date), month(order_date),1) as month,
        sum(sales_amount) as monthly_sales
        from gold.fact_sales as fs
        left join gold.dim_products as dp
        on fs.product_key = dp.product_key
        group by dp.category,DATEFROMPARTS(year(order_date), month(order_date),1)
        )
         select * from
        (select *,
                lag(monthly_sales)over(partition by category order by month) as prev_monthsales,

                round(100.0*(monthly_sales-lag(monthly_sales)over(partition by category order by month))
                /
                lag(monthly_sales)over(partition by category order by month),2) as growth

                from cte1
                )t
                where growth>0

