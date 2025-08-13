with skills_demand as (
    select
        skills_dim.skill_id,
        skills_dim.skills as skill,
        count(job_posted_date) as skill_count
    from job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where
        job_title_short = 'Data Analyst' and
        job_work_from_home = True
    group by skills_dim.skill_id
), average_salary as (
    select
        skills_job_dim.skill_id,
        round(avg(salary_year_avg)) as avg_salary
    from job_postings_fact
    inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where
        salary_year_avg is not null AND
        job_title_short = 'Data Analyst' AND
        job_work_from_home is TRUE
    group by skills_job_dim.skill_id
    HAVING
        count(job_posted_date) > 0
)

select
    skills_demand.skill_id,
    skills_demand.skill,
    skill_count,
    avg_salary
from
    skills_demand
inner join average_salary on skills_demand.skill_id = average_salary.skill_id
order by 
    skill_count DESC,
    avg_salary desc
limit 25;

--rewrite but better
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    count(job_posted_date) as skill_count,
    round(avg(salary_year_avg)) as avg_salary
from job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where
    job_title_short = 'Data Analyst' and
    salary_year_avg is not NULL
group by skills_dim.skill_id
order by
    skill_count desc,
    avg_salary desc
