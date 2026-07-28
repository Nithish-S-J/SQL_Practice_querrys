/*For every customer, identify their favorite category.

Favorite category is defined as:

Highest total revenue.
If revenue ties, choose the category with the highest number of orders.
If there's still a tie, choose the category that was purchased first.
Return
customer_id
customer_name
favorite_category
category_revenue
category_orders
first_purchase_date */

with cte1 as
(
select 
      dc.customer_id,
      dc.first_name,
      dp.category,
      sum(sales_amount) as category_revenue,
      DATEFROMPARTS(year(min(order_date)),month(min(order_date)),1) as first_purchase_date,
      count(*) as category_orders
      from gold.fact_sales as fs
      left join gold.dim_customers as dc 
      on fs.customer_key = dc.customer_key
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      group by dc.customer_id,
               dc.first_name,
               dp.category
               )
               ,cte2 as
               (select *,
                       ROW_NUMBER()OVER(
                                        PARTITION BY customer_id
                                        ORDER BY  category_revenue DESC, 
                                        category_orders DESC,
                                        first_purchase_date ASC) as rn 
                                         
                                        from cte1 
                                        )
                                        select * from cte2
                                        where rn = 1
