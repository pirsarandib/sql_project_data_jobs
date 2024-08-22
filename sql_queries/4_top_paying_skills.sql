/*
Question 4: What are the paying skills for data analyst?
*/
SELECT 
       ROUND(AVG(salary_year_avg)) AS avg_salary,
       skills
FROM 
      job_postings_fact
LEFT JOIN
      skills_job_dim ON
      job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN
      skills_dim ON
      skills_dim.skill_id =  skills_job_dim.skill_id 

WHERE
      job_title_short = 'Data Analyst' AND
      job_work_from_home = TRUE AND
      salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY
      avg_salary DESC
LIMIT 10;
