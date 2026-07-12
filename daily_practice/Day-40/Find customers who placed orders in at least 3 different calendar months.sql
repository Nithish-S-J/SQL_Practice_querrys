/*Find customers who placed orders in at least 3 different calendar months.

Return:

customer_id
customer_name
country
active_months
total_sales */


select
      dc.customer_id,
      concat(dc.first_name, ' ', dc.last_name) as customer_name,
      dc.country,
      count(distinct(DATEFROMPARTS(year(order_date),month(order_date),1))) as active_months,
      sum(sales_amount) as total_sales
     from gold.fact_sales as fs
     left join gold.dim_customers as dc
     on fs.customer_key = dc.customer_key
     group by dc.customer_id,concat(dc.first_name, ' ', dc.last_name),dc.country
     having count(distinct(DATEFROMPARTS(year(order_date),month(order_date),1))) >= 3
