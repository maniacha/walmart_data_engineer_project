{{ config(
    materialized='table',
    schema='gold'
) }}
select 
    distinct 
        product_id,
        product_name,
        product_category,
        product_brand,
        product_price,
        product_created_timestamp,
        product_updated_timestamp,
        product_is_active,
        product_processed_at,
        current_timestamp() as eph_product_processed_at
from {{ref('obt')}}
