---------Find customers whose sales increased
-----for 3 consecutive months.

with cte1 as
(
select
      dc.customer_id,
      DATEFROMPARTS(year(order_date),month(order_date),1) as month,
      sum(sales_amount) as monthly_sales
      from gold.fact_sales as fs
      left join gold.dim_customers as dc
      on fs.customer_key = dc.customer_key
      group by dc.customer_id, DATEFROMPARTS(year(order_date),month(order_date),1)
      )
      , prev_sales as
      (select *,
              lag(monthly_sales,1)over(partition by customer_id order by month) as lag1,
               lag(monthly_sales,2)over(partition by customer_id order by month) as lag2,
                lag(monthly_sales,3)over(partition by customer_id order by month) as lag3
                from cte1)

                select * from prev_sales
                where monthly_sales > lag1 and lag1 > lag2 and lag2 > lag3

