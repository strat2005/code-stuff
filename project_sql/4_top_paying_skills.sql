select
    skills,
    round(avg(salary_year_avg)) as avg_salary
from job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where
    salary_year_avg is not null
group by skills
order by avg_salary desc;

select
    skills,
    round(avg(salary_year_avg)) as avg_salary,
    count(job_posted_date) as skill_count
from job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where
    salary_year_avg is not null AND
    job_title_short = 'Data Analyst'
group by skills
HAVING
    count(job_posted_date) > 500
order by avg_salary desc;
