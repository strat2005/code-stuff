with top_paying_jobs as (
    SELECT
        job_id,
        company_dim.name,
        job_title_short,
        job_location,
        salary_year_avg
    from job_postings_fact
    left join company_dim on job_postings_fact.company_id = company_dim.company_id
        where 
        job_work_from_home = TRUE AND
        salary_year_avg is not null AND
        job_title_short = 'Data Analyst'
    order by salary_year_avg DESC
    limit 10
)

select
    top_paying_jobs.*,
    skills_dim.skills
from top_paying_jobs
inner join skills_job_dim on top_paying_jobs.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id