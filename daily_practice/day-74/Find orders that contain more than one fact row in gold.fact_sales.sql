/*Find orders that contain more than one fact row in gold.fact_sales.

Return
order_number
order_date
customer_id
customer_name
product_count */


select 
       fs.order_number,
       fs.order_date,
       dc.customer_id,
       dc.first_name as customer_name,
       count(fs.product_key) as product_count
       from gold.fact_sales as fs
       left join gold.dim_customers as dc
       on fs.customer_key = dc.customer_key
       group by fs.order_number,
                fs.order_date,
                dc.customer_id,
                dc.first_name
                having  count(fs.product_key) >1
      
       
