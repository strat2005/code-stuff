/*
count most demanded skills
*/
select
    skills,
    count(job_posted_date) as skill_count
from job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where
    job_title_short = 'Data Analyst' and
    job_work_from_home = True
group by skills
order by skill_count desc
