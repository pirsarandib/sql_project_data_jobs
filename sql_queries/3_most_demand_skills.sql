/*
Question 3: What are the most demand skills for data analyst?
- Identify most demand skills for remote data analysts
- Focus on all jobs
- Why?
- Providing insigts into top demand skills
*/
SELECT 
       COUNT(skills) AS skills_counts,
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
      job_work_from_home = TRUE
GROUP BY skills
ORDER BY
      skills_counts DESC 
LIMIT 5;
