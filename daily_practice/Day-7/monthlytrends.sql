---Q1. Monthly Customer Spending Trend---
--Find: -customer_id--month--total orders--total sales
--Only for customers whose monthly sales are greater than 3000.--


select customer_id,
       datetrunc(MONTH,order_date) as ordermonth,
       count(order_id) as totalorders,
       sum(order_value_inr) as totalsales
       from fact_orders
       group by  customer_id,
       datetrunc(MONTH,order_date)
       having sum(order_value_inr) < 3000
    

           


 
