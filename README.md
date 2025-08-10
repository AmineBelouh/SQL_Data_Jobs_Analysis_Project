# Introduction

📊 Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and where high demand meets high salary in data analytics.  

Check my SQL queries here: [sql_project folder](/sql_project/) 

# Background  

This project was created to better understand the data analyst job market, with the goal of identifying the highest-paying and most in-demand skills to help others find the best job opportunities.  

The data comes from Luke Barousse's [SQL course](https://lukebarousse.com/sql). It’s full of details on job titles, salaries, locations, and key skills.

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

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.  


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

Here's the breakdown of the top data analyst jobs in 2023:  
- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.   
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.  
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.  

### 2. Skills for Top Paying Jobs  

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.  

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

Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:  
- **SQL** is leading with a count of 8.  
- **Python** follows with a count of 7.  
- **Tableau** is also highly sought after, with a count of 6.  
Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.  

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

Here's the breakdown of the most demanded skills for data analysts in 2023:
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.  

| Skills   | Postings Count |
|----------|----------------|
| SQL      | 7291           |
| Excel    | 4611           |
| Python   | 4330           |
| Tableau  | 3745           |
| Power BI | 2609           |  

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

Here's a breakdown of the results for top paying skills for Data Analysts:
- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.  

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |  

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
    avg_salary DESC,
    postings_count DESC;
```  

Here's a breakdown of the most optimal skills for Data Analysts in 2023: 
- **High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.  

# What I Learned  

Throughout this project, I enhanced my SQL skills in several key areas:

- **Complex Query Crafting**: Gained proficiency in writing SQL queries, including table joins and the use of WITH clauses for temporary result sets.

- **Data Aggregation**: Developed strong skills in using GROUP BY and aggregate functions such as COUNT() and AVG() to summarize data effectively.

- **Analytical Thinking**: Improved my ability to translate real-world questions into actionable SQL queries that deliver meaningful insights.  

# Conclusions  

From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers with a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.  

### Closing Thoughts  

 This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand and high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.