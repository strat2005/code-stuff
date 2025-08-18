# Introduction
The goal of the project is to dive into the data job market. Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills and where high demand meets high salary in data analytics

To check out the SQL queries used, check in the link here: [project_sql folder](/project_sql/)
# Background
Throughout this project, there were five main questions I wanted to answer
1. What are the top paying data-analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most high in demand for data analyst jobs?
4. Which skills are associated with higher salary jobs?
5. What are the most optimal skills to learn?
# Tools I used
For this project, I utilized three key tools used in data analytics:
- SQL: The foundation of my analysis, allowing me to query the database and gain useful insights
- PostgresSQL: The chosen database management system, ideal for handling the job postings data
- Visual Studio Code: Used for data management and executing SQL queries
- Git & Github: Essential for version control and sharing SQL scripts and analysis, ensuring collaboration and project
# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field

```sql
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
```
Here's the breakdown of the top data analyst jobs in 2023:

- **Wide Salary Range**: Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers**: Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety**: There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

![Top Paying Roles](assets\image.png)
*Bar graph visualizing the salary for the top 10 salaries for data analysts*

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
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
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:

- **SQL** is leading with a bold count of 8.
- **Python** follows closely with a bold count of 7.
- **Tableau** is also highly sought after, with a bold count of 6. Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.
![Top Paying Job Skills](assets\image copy.png)
*Bar graph visualizing the count of skills for the top 10 paying jobs for data analysts*

### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.
```sql
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
```
Here's the breakdown of the most demanded skills for data analysts in 2023

- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- Programming and Visualization Tools like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
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
```
Here's a breakdown of the results for top paying skills for Data Analysts:

- **High Demand for Big Data & ML Skills**: Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency**: Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise**: Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.
```sql
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
    avg_salary desc;
```
Here's a breakdown of the most optimal skills for Data Analysts in 2023:

- **High-Demand Programming Languages**: Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies**: Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools**: Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies**: The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.
# What I learned
Throughout this deep dive, I've improved my SQL toolkit with some very useful skills:

- **Complex Query Crafting**: Mastered the art of advanced SQL, merging tables like a pro and wielding WITH clauses for ninja-level temp table maneuvers.
- **Data Aggregation**: Got cozy with GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks.
- **Analytical Thinking**: Leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.
# Conclusion
## Insights
From the analysis, several general insights emerged:

- **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
Skills for Top-Paying Jobs: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
- **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
Skills with Higher Salaries: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
- **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.