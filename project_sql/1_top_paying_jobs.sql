/*
top paying data analyst roles remotely
*/

--query 1

SELECT
    company_name,
    job_title_short,
    job_location,
    salary_year_avg
from job_postings_fact
where 
    job_work_from_home = TRUE AND
    salary_year_avg is not null AND
    job_title_short = 'Data Analyst'
left join company_dim on job_postings_fact.company_id = company_dim.company_id
order by salary_year_avg DESC
limit 10;

select *
from skills_dim
limit 5