COPY company_dim
FROM 'C:/Data_Analyst_Journey/Luke Barousse/SQL/SQL_Project_Data_Job_Analysis/csv_files_bonus/company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM 'C:/Data_Analyst_Journey/Luke Barousse/SQL/SQL_Project_Data_Job_Analysis/csv_files_bonus/skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM 'C:/Data_Analyst_Journey/Luke Barousse/SQL/SQL_Project_Data_Job_Analysis/csv_files_bonus/job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM 'C:/Data_Analyst_Journey/Luke Barousse/SQL/SQL_Project_Data_Job_Analysis/csv_files_bonus/skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');