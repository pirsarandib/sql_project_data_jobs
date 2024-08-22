/*
  Question 2: What are the top skills for 100 data analyst top paying jobs
  1.	SQL (75 mentions): SQL tops the list, indicating that it’s a fundamental skill for data analysts
	2.	Python (52 mentions): its versatility in data manipulation, analysis, and automation tasks.
	3.	Tableau (41 mentions): Tableau’s frequent mention highlights its importance in data visualization, enabling analysts to create interactive dashboards and reports.
  4.	R (33 mentions): R is commonly used for statistical analysis and data visualization, showing its relevance in analytical roles.
	5.	SAS (28 mentions): SAS is widely used in industries like finance and healthcare for advanced analytics, which might explain its presence.
*/

WITH company_jobs AS (
    SELECT 
        job_postings_fact.job_id,
        job_postings_fact.company_id,
        company_dim.name AS company_name,
        job_postings_fact.salary_year_avg,
        job_postings_fact.job_title,
        job_postings_fact.job_title_short,
        job_postings_fact.job_location
    FROM 
        job_postings_fact
    LEFT JOIN 
        company_dim 
    ON 
        job_postings_fact.company_id = company_dim.company_id
),
job_skills AS (
    SELECT 
        skills_job_dim.job_id,
        STRING_AGG(skills_dim.skills, ', ') AS skills
    FROM 
        skills_job_dim
    LEFT JOIN 
        skills_dim 
    ON 
        skills_job_dim.skill_id = skills_dim.skill_id
    GROUP BY 
        skills_job_dim.job_id
),
final_result AS (
    SELECT 
        company_jobs.job_id,
        company_jobs.company_name,
        company_jobs.job_title, 
        company_jobs.job_title_short, 
        company_jobs.salary_year_avg,
        job_skills.skills
    FROM 
        company_jobs
    LEFT JOIN 
        job_skills 
    ON 
        company_jobs.job_id = job_skills.job_id
    WHERE 
        company_jobs.salary_year_avg IS NOT NULL 
        AND company_jobs.job_title_short = 'Data Analyst' 
        AND company_jobs.job_location = 'Anywhere'
)
SELECT 
    job_id,
    job_title,
    company_name,
    salary_year_avg,
    skills
FROM 
    final_result
ORDER BY 
    salary_year_avg DESC 
LIMIT 100;




/* Without CTE
SELECT 
       job_postings_fact.job_id AS job_id,
       company_dim.name AS company_name,
       job_postings_fact.job_title,
       job_postings_fact.salary_year_avg,
       job_postings_fact.job_posted_date::date,
       STRING_AGG(skills_dim.skills, ', ') AS skills
FROM 
      job_postings_fact
LEFT JOIN
      company_dim ON
      job_postings_fact.company_id = company_dim.company_id
LEFT JOIN
      skills_job_dim ON
      job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN
      skills_dim ON
      skills_dim.skill_id =  skills_job_dim.skill_id 

WHERE
      salary_year_avg IS NOT NULL AND
      job_title_short = 'Data Analyst' AND
      job_location = 'Anywhere'

GROUP BY 
        job_postings_fact.job_id, company_dim.name
ORDER BY
      salary_year_avg DESC 
LIMIT 100;
*/