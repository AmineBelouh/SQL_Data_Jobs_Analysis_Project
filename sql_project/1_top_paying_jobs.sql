SELECT
    job_postings.job_id,
    job_postings.job_title,
    company_dim.name AS company_name,
    job_postings.job_location,
    job_postings.job_schedule_type,
    job_postings.salary_year_avg,
    job_postings.job_posted_date::DATE
FROM 
    job_postings_fact AS job_postings
INNER JOIN company_dim ON job_postings.company_id = company_dim.company_id
WHERE
    job_postings.job_title_short = 'Data Analyst'
    AND job_postings.job_location = 'Anywhere'
    AND job_postings.salary_year_avg IS NOT NULL
ORDER BY 
    job_postings.salary_year_avg DESC
LIMIT 10;