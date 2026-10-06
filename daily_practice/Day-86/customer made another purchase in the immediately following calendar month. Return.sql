/*For every customer's first purchase month, determine whether that customer made another purchase in the immediately following calendar month.
Return
customer_id
customer_name
first_purchase_month
next_month_purchase */

with cte1 as
(
select distinct 
       dc.customer_id,
       dc.first_name,
       DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month
       from gold.fact_sales as fs
       left join gold.dim_customers  as dc
       on fs.customer_key = dc.customer_key
       )
       , cte2 as
               (select *,
               row_number()over(partition by customer_id order by sales_month) as rn
               from cte1 
               )
              ,cte3 as
                      (select *,
                       lead(sales_month)over(partition by customer_id order by sales_month) as next_purchase_month
                       from cte2
                       )
                       select *,
                              CASE
        WHEN DATEDIFF(month, sales_month, next_purchase_month) = 1
            THEN 'Yes'
        ELSE 'No'
    END AS next_month_purchase
                               from cte3
                       where rn = 1
