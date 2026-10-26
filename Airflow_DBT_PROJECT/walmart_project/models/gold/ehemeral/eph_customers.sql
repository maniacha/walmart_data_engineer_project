-- eph_customers.sql

{{ config(
    materialized='table',
    schema='gold'
) }}

select  
    distinct
                customer_id,
                customer_first_name,
                customer_last_name,
                customer_email,
                customer_phone_number,
                customer_city,
                customer_province,
                customer_country,
                customer_created_timestamp,
                customer_updated_timestamp,
                customer_is_active,
                customer_processed_at,
                current_timestamp() as eph_customer_processed_at
from {{ref('obt')}}