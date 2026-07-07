---Find all products that have never appeared in gold.fact_sales.
---Return: product_key, product_name, category, subcategory, start_date

select dp.product_key,
       dp.product_name,
       dp.category,
       dp.subcategory,
       order_date as start_date
       from gold.dim_products as dp 
       left join gold.fact_sales as fs
       on fs.product_key = dp.product_key
       where fs.product_key is null
      
