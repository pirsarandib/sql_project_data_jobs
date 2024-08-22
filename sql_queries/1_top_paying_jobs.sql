/* Question 1: What are the top paying remote data analyst jobs?
 - identifying 100 top paying jobs
 - remove nulls
*/


SELECT 
       job_id,
       company_dim.name AS company_name,
       job_title,
       salary_year_avg,
       job_posted_date::date
FROM 
      job_postings_fact
LEFT JOIN
      company_dim ON
      job_postings_fact.company_id = company_dim.company_id
WHERE
      salary_year_avg IS NOT NULL AND
      job_title_short = 'Data Analyst' AND
      job_location = 'Anywhere'


ORDER BY
      salary_year_avg DESC 
LIMIT 100;


