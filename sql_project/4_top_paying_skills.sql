SELECT
    skills_dim.skills,
    ROUND(AVG(job_postings.salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact AS job_postings
INNER JOIN skills_job_dim ON job_postings.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings.job_title_short = 'Data Analyst'
    AND job_postings.job_location = 'Anywhere'
    AND job_postings.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY
    avg_salary DESC
LIMIT 25;