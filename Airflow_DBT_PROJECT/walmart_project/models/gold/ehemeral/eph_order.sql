{{ config(
    materialized='table',
    schema='gold'
) }}
select 
    distinct 
       order_id,
       order_item_id,
       order_status,
       order_payment_method,
       order_timestamp,
       order_created_timestamp,
       order_updated_timestamp,
       order_is_active,
       order_processed_at,
       obt_processed_at,
       current_timestamp() as eph_order_processed_at
from {{ref('obt')}}