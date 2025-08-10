SELECT
    skills_dim.skills,
    COUNT(job_postings.job_id) AS postings_count
FROM 
    job_postings_fact AS job_postings
INNER JOIN skills_job_dim ON job_postings.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings.job_title_short = 'Data Analyst'
    AND job_postings.job_location = 'Anywhere'
GROUP BY
    skills_dim.skills
ORDER BY 
    postings_count DESC
LIMIT 5;