--Assume you're given the tables containing completed trade orders and user details in a Robinhood trading system.
--Write a query to retrieve the top three cities that have the highest number of completed trade orders listed in descending order. 
--Output the city name and the corresponding number of completed trade orders.

WITH city_orders AS
(
    SELECT
        u.city,
        COUNT(*) AS total_orders
    FROM trades t
    JOIN users u
        ON t.user_id = u.user_id
    WHERE t.status = 'Completed'
    GROUP BY u.city
)

SELECT
    city,
    total_orders
FROM
(
    SELECT
        *,
        DENSE_RANK() OVER(ORDER BY total_orders DESC) AS rn
    FROM city_orders
) t
WHERE rn <= 3
ORDER BY total_orders DESC;
