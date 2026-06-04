---Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each user’s 
--first post of the year and last post of the year in the year 2021.
----Output the user and number of the days between each user's first and last post


SELECT user_id,
      datediff(max(post_date),min(post_date)) as daysbetween
      from posts
      where year(post_date) = 2021
      group by user_id
      having count(post_id) >=2
