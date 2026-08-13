/*Find customers who:

Started by purchasing from exactly one category in their first purchase month.
Later purchased from at least 3 distinct categories in a subsequent month.
Return
customer_id
customer_name
first_purchase_month
first_month_categories
expansion_month
categories_in_expansion_month
first_month_revenue
expansion_month_revenue */

with cte1 as
(
select  
         dc.customer_id,
         dc.first_name as customer_name,
         DATEFROMPARTS(year(min(order_date)),month(min(order_date)),1) as first_purchase_month,
         sum(sales_amount) as first_month_revenue
        from gold.fact_sales as fs 
        left join gold.dim_customers as dc
        on fs.customer_key = dc.customer_key       
        group by dc.customer_id,dc.first_name
        )
        , cte2 as
        (select dc.customer_id,
                DATEFROMPARTS(year(order_date),month(order_date),1) as sales_month,
                count(distinct category) as categories_in_month,
                sum(sales_amount) as monthly_revenue
                from gold.fact_sales as fs
                left join gold.dim_customers as dc
                on fs.customer_key = dc.customer_key
                left join gold.dim_products as dp
                on fs.product_key = dp.product_key
                group by customer_id,
                         DATEFROMPARTS(year(order_date),month(order_date),1)
                         )
                         , cte3 as
                         
(
    -- Attach first-month information to every customer month
    SELECT
        c2.customer_id,
        c1.customer_name,
        c1.first_purchase_month,

        c2.sales_month,
        c2.categories_in_month,
        c2.monthly_revenue,

        FIRST_VALUE(c2.categories_in_month) OVER(
            PARTITION BY c2.customer_id
            ORDER BY c2.sales_month
        ) AS first_month_categories,

        FIRST_VALUE(c2.monthly_revenue) OVER(
            PARTITION BY c2.customer_id
            ORDER BY c2.sales_month
        ) AS first_month_revenue

    FROM cte2 AS c2
    INNER JOIN cte1 AS c1
        ON c2.customer_id = c1.customer_id
),

cte4 AS
(
    -- Find the first month where customer expanded to 3+ categories
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY customer_id
            ORDER BY sales_month
        ) AS rn
    FROM cte3
    WHERE sales_month > first_purchase_month
      AND first_month_categories = 1
      AND categories_in_month >= 3
)

SELECT
    customer_id,
    customer_name,
    first_purchase_month,
    first_month_categories,
    sales_month AS expansion_month,
    categories_in_month AS categories_in_expansion_month,
    first_month_revenue,
    monthly_revenue AS expansion_month_revenue
FROM cte4
WHERE rn = 1
ORDER BY customer_id;
