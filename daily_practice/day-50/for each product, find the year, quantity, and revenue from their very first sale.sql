/*  for each product, find the year, quantity, and revenue from their very first sale. */

with cte1 as
(
select 
       dp.product_id,
       order_date as first_sale,
       quantity,
       sales_amount,
       rank()over(partition by product_id order by order_date) as rn
       from gold.fact_sales as fs
       left join gold.dim_products as dp
       on fs.product_key = dp.product_key
       
       )
       , cte2 as
       (
       select product_id,
               year(first_sale) as first_year,
               sum(quantity) as total_quantity,
               sum(sales_amount) as total_sales
               from cte1
               where rn = 1
               group by product_id, year(first_sale)
               )
               select * from cte2
