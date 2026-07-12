/*Find customers who purchased products from at least 3 different categories.

Return:

customer_id
customer_name
country
categories_purchased
total_sales */

select
       dc.customer_id,
       concat(dc.first_name,' ',dc.last_name) as customer_name,
       dc.country,
       count(distinct dp.category) as nr_category,
       sum(sales_amount) as total_sales
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      left join gold.dim_products as dp
      on fs.product_key = dp.product_key
      group by dc.customer_id,concat(dc.first_name,' ',dc.last_name)
                ,dc.country
      having  count(distinct dp.category) >= 3
