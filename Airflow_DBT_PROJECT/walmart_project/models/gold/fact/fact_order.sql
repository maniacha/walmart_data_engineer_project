{{ config(
    materialized='table',
    schema='gold'
) }}
select 
    order_id,
    order_item_id,
    product_id,
    store_id,
    employee_id,
    customer_id,
    order_total_amount,
    order_item_quantity,
    order_item_unit_price
from    
    {{ref('obt')}}