# Data Analyst Job Market Analysis

## Project Overview

This project explores the current job market for remote Data Analyst positions, focusing on identifying the top-paying jobs, in-demand skills, and the skills that command the highest salaries. The analysis is based on a dataset of job postings, enriched with information about the required skills and compensation offered by different companies.

## Purpose

The goal of this project is to provide insights into the remote Data Analyst job market, helping aspiring data analysts understand:
- Which companies offer the highest salaries for remote Data Analyst positions.
- The top skills that are associated with these high-paying jobs.
- The most demanded skills in the market.
- The skills that provide the highest average salaries.
- The skills that aspiring data analysts should prioritize learning based on demand and compensation.

## Dataset

The analysis was conducted using a dataset that includes job postings with associated skills and salary information. The dataset comprises several tables:
- `job_postings_fact`: Contains information about job postings, including job titles, locations, and salaries.
- `company_dim`: Holds details about companies posting the jobs.
- `skills_dim`: Lists the skills required for each job.
- `skills_job_dim`: A linking table between jobs and their required skills.

## Questions Answered

### 1. What Are the Top Paying Remote Data Analyst Jobs?
**Insights:** This query identifies the top-paying remote Data Analyst jobs, allowing job seekers to target their applications more strategically.

```sql
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
```
### 2. What Are the Top Skills for 100 Top Paying Data Analyst Jobs?
**Insights:** SQL, Python, Tableau, R, and SAS are the top skills mentioned in these lucrative job postings, highlighting their importance in securing high-paying positions

```sql
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
```

### 3. What Are the Most Demanded Skills for Remote Data Analyst Jobs?
**Insights:** This analysis provides a clear picture of the most sought-after skills for remote Data Analyst roles, guiding professionals on where to focus their skill development.

```sql
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
```


### 4. What Are the Top Paying Skills for Data Analysts?
**Insights:** The skills listed in this query are those that offer the highest compensation, indicating their premium value in the job market.

```sql
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
      skills_dim.skill_id = skills_job_dim.skill_id 
WHERE
      job_title_short = 'Data Analyst' AND
      job_work_from_home = TRUE AND
      salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY
      avg_salary DESC
LIMIT 10;
```

### 5.What Are the Most Demanded Skills to Learn for a Data Analyst?
**Insights:** This analysis guides data analysts on which skills to prioritize based on both demand and salary, ensuring they invest their time and resources wisely.

```sql
SELECT 
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

## Future Work

- **Extend the Analysis**: Include additional job roles within the data science domain, such as machine learning engineers, data engineers, and business analysts.
- **Incorporate Time Series Analysis**: Implement time series analysis to track how demand for skills and salaries evolve over time.
- **Explore Predictive Modeling**: Utilize machine learning techniques to predict future trends in the job market, offering insights into emerging skills and changing salary expectations.
