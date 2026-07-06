----Find products that were sold in a month after having no sales during the previous 2 complete calendar months.
--- Return:product_key, product_name, return_month, previous_active_month, inactive_months

with cte1 as
(
select distinct
       dp.product_key,
       dp.product_name,
       DATEFROMPARTS(year(order_date),month(order_date),1) as order_month
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key =  dp.product_key
       )
       , cte2 as 
       (select *,
               lag(order_month) over(partition by product_key order by order_month) as previous_active_month
               from cte1)
              
               select *,
                        datediff(month, previous_active_month, order_month) - 1 as inactive_months
                        from cte2
               where datediff(month, previous_active_month, order_month) >= 3
            
