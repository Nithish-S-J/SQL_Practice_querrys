/*The Product team wants to identify products that have never generated a sale.

Return
product_key
product_name
category
subcategory
start_date */


select 
       dp.product_key,
       product_name,
       category,
       subcategory,
       start_date  
      from gold.dim_products as dp
      left join gold.fact_sales  as fs
      on dp.product_key = fs.product_key
      where fs.product_key is null
                 
