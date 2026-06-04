---Assume you're given a table containing job postings from various companies on the LinkedIn platform.
----Write a query to retrieve the count of companies that have posted duplicate job listings.

--Definition:

---Duplicate job listings are defined as two job listings within the same company that share identical titles and descriptions.

with cte AS(
SELECT  company_id
FROM job_listings
group by company_id, title, description
having count(job_id) > 1)
select count(distinct company_id) as duplicatejobs
from cte
