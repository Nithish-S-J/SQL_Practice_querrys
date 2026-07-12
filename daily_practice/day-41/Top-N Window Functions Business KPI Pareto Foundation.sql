/* For every country, calculate
Top 5 customer revenue
Country revenue
Contribution %
Return
country
top5_customer_revenue
country_revenue
top5_contribution_pct */

with cte1 as
(
select 
        dc.country,
        dc.customer_id,
        sum(sales_amount) as total_sales,
        rank()over(partition by country order by sum(sales_amount)desc) as rn
        from gold.fact_sales as fs
        left join gold.dim_customers as dc
        on fs.customer_key = dc.customer_key
        group by country, dc.customer_id
        )
        , cte2 as
        (select country,
                sum(total_sales) as top5_country_revenue
                from cte1
                where rn <=5
                group by country
                )
                ,cte3 as 
                (select country,
                        sum(total_sales) as country_sales
                        from cte1
                        group by country
                        )
                        select *,
                               round(100.0*top5_country_revenue/country_sales,2) as contribution_pct
                               from cte2 as c2
                               join cte3 as c1
                               on c2.country = c1.country
                               
