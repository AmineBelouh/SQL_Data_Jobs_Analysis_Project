# Introduction

📊 Dive into the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and optimal skills.    

Check my SQL queries here: [sql_project folder](/sql_project/) 

# Background  

This project was created to better understand the data analyst job market, with the goal of identifying the highest-paying and most in-demand skills to help others find the best job opportunities.  

The dataset used is from Luke Barousse's app [datanerd.tech](https://datanerd.tech/).  

### The questions I wanted to answer through my SQL queries were:  

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used  

**SQL**: The backbone of my analysis, allowing me to query the database and unearth critical insights.  
**PostgreSQL**: The chosen database management system.  
**Visual Studio Code**: My go-to for database management and executing SQL queries.  
**Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# Analysis  

Each query for this project aimed at investigating specific aspects of the data analyst job market, with a focus on **remote offers**.  

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I ordered the data by average yearly salary in descending order.    


```sql
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
```

Here's the breakdown of the top data analyst jobs:  
- **Wide Salary Range:** Top 10 paying data analyst roles span from $255,829 to $445,000, indicating significant salary potential in the field.   
- **Diverse Employers:** Companies like Netflix, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.  
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.  

### 2. Skills for Top Paying Jobs  

To see what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.  

```sql
WITH top_paying_jobs AS (
    SELECT
        job_postings.job_id,
        job_postings.job_title,
        company_dim.name AS company_name,
        job_postings.salary_year_avg
    FROM 
        job_postings_fact AS job_postings
    INNER JOIN company_dim ON job_postings.company_id = company_dim.company_id
    WHERE
        job_postings.job_title_short = 'Data Analyst'
        AND job_postings.job_location = 'Anywhere'
        AND job_postings.salary_year_avg IS NOT NULL
    ORDER BY 
        job_postings.salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills_dim.skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    top_paying_jobs.salary_year_avg DESC;
```  

Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs:  
- **SQL** is leading with a count of 6.  
- **Python** follows with a count of 4.    
- Other skills like **Tableau** and **Excel** show varying degrees of demand.  

### 3. In-Demand Skills for Data Analysts  

This query helped identify the skills most frequently requested in job postings. 

```sql
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
```   

| Skills   | Postings Count |
|----------|----------------|
| SQL      | 15300          |
| Python   | 9980           |
| Excel    | 9278           |
| Tableau  | 8218           |
| Power BI | 5950           |  

*Table of the demand for the top 5 skills in data analyst job postings*

### 4. Skills Based on Salary  

Exploring the average salaries associated with different skills revealed which skills are the highest paying.  

```sql
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
```  

Employers place a premium on niche expertise in emerging and in-demand technologies.  

| Skill       | Average Salary ($)  |
|-------------|---------------------|
| typescript  | 445,000             |
| graphql     | 264,000             |
| node        | 201,875             |
| bitbucket   | 189,155             |
| trello      | 171,396             |
| pyspark     | 161,971             |
| scala       | 161,446             |
| couchbase   | 160,515             |
| perl        | 158,000             |
| datarobot   | 155,486             |  

*Table of the average salary for the top 10 paying skills for data analysts*  

### 5. Most Optimal Skills to Learn  

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.  

```sql
SELECT
    skills_dim.skills,
    COUNT(job_postings.job_id) AS postings_count,
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
HAVING
    COUNT(job_postings.job_id) > 10
ORDER BY
    postings_count DESC,
    avg_salary DESC;
```  

Here's a breakdown of the most optimal skills for Data Analysts: 
- **High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 495 and 289 respectively. Their average salaries are around $98,061 for Python and $97,421 for R.  
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Power BI, with demand counts of 505 and 294 respectively, and average salaries around $102,172 and $95,550, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $96,244 to $105,392, reflects the enduring need for data storage, retrieval, and management expertise.  

# What I Learned  

Throughout this project, I enhanced my SQL skills in several key areas:

- **Complex Query Crafting**: Gained proficiency in writing SQL queries, including table joins and the use of WITH clauses for temporary result sets.

- **Data Aggregation**: Developed strong skills in using GROUP BY and aggregate functions such as COUNT() and AVG() to summarize data effectively.

- **Analytical Thinking**: Improved my ability to translate real-world questions into actionable SQL queries that deliver meaningful insights.  

# Conclusions  

From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $445,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand with a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.  

### Closing Thoughts  

 This project enhanced my SQL skills and provided valuable insights into the data analyst job market. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand and high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.