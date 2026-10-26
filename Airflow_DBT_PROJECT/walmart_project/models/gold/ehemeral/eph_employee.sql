{{ config(
    materialized='table',
    schema='gold'
) }}
select  
    distinct 
        employee_id,    
        employee_first_name,
        employee_last_name,
        employee_email,
        employee_salary,
        employee_job_title,
        store_id,
        employee_created_timestamp,
        employee_updated_timestamp,
        employee_is_active,
        employee_processed_at,
        current_timestamp() as eph_employee_processed_at
from {{ref('obt')}}