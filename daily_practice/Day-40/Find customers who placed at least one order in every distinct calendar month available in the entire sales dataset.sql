------Find customers who placed at least one order in every distinct calendar month available in the entire sales dataset.
-----Return:customer_id, customer_name, active_months, total_dataset_months

with cte1 as
(
select 
      dc.customer_id,
      concat(dc.first_name, ' ', dc.last_name) as customer_name,
      count(distinct DATEFROMPARTS(year(order_date),month(order_date),1)) as active_months,

      (select 
             count(distinct DATEFROMPARTS(year(order_date),month(order_date),1))
                   from gold.fact_sales
                   where order_date is not null ) as total_dataset_months


                   from gold.fact_sales as fs
                   left join gold.dim_customers as dc
                   on fs.customer_key = dc.customer_key
                   where fs.order_date is not null
                     GROUP BY dc.customer_id, CONCAT(dc.first_name, ' ', dc.last_name))
              
              select 
                    customer_id,
                    customer_name,
                    active_months,
                    total_dataset_months
                    from cte1
                    
