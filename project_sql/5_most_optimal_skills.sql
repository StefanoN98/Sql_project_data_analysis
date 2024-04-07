 WITH skills_demand AS (
SELECT skills_dim.skill_id, skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id= skills_dim.skill_id
WHERE job_title_short='Data Analyst' AND salary_year_avg IS NOT NULL AND job_work_from_home=true
GROUP BY skills_dim.skill_id
),

Average_salary AS (
        SELECT skills_job_dim.skill_id,
        round(AVG(salary_year_avg),0) as Avg_salary
        FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id= skills_dim.skill_id
        WHERE job_title_short='Data Analyst' AND salary_year_avg IS NOT NULL AND job_work_from_home=true
        GROUP BY skills_job_dim.skill_id
         )


SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    Avg_salary
FROM skills_demand
INNER JOIN Average_salary ON skills_demand.skill_id = Average_salary.skill_id
WHERE demand_count>10
ORDER BY demand_count DESC, Avg_salary DESC
limit 25