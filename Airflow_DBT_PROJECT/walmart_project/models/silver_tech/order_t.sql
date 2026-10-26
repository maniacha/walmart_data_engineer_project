{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

select
    *,
    current_timestamp() as processed_timestamp
from {{ source('walmart', 'orders') }}

{% if is_incremental() %}

where updated_timestamp >
(
    select coalesce(max(updated_timestamp), timestamp('1900-01-01'))
    from {{ this }}
)

{% endif %}