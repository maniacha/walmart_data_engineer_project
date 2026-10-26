{%set configs =[
        {
            "table": "walmart.silver_tech.order_t",
            "columns": """  o.order_id,
                            o.store_id,
                            o.order_status,
                            o.order_timestamp,
                            o.payment_method as order_payment_method,
                            o.total_amount as order_total_amount,
                            o.created_timestamp as order_created_timestamp,
                            o.updated_timestamp as order_updated_timestamp,
                            o.is_active as order_is_active,
                            o.processed_timestamp as order_processed_at,
                            current_timestamp() as obt_processed_at
                        """,
            "alias":"o"
        },

        {
            "table": "walmart.silver_tech.order_items",
            "columns": """  oi.order_item_id,
                            oi.quantity as order_item_quantity,
                            oi.unit_price as order_item_unit_price,
                            oi.created_timestamp as order_item_created_timestamp,
                            oi.updated_timestamp as order_item_updated_timestamp,
                            oi.is_active as order_item_is_active,
                            oi.processed_timestamp as order_item_processed_at
                        """,
            "alias": "oi",
            "join_condition": "o.order_id = oi.order_id"
        },
        {
            "table": "walmart.silver_tech.products_t",
            "columns": """p.product_id,
                            p.product_name as product_name,
                            p.category as product_category,
                            p.brand as product_brand,
                            p.price as product_price,
                            p.created_timestamp as product_created_timestamp,
                            p.updated_timestamp as product_updated_timestamp,
                            p.is_active as product_is_active,
                            p.processed_timestamp as product_processed_at
                        """,
            "alias": "p",
            "join_condition": "oi.product_id = p.product_id"
        },
        {
            "table": "walmart.silver_tech.stores",
            "columns": """  s.store_name as store_name,
                            s.city as store_city,
                            s.province as store_province,
                            s.country as store_country,
                            s.created_timestamp as store_created_timestamp,
                            s.updated_timestamp as store_updated_timestamp,
                            s.is_active as store_is_active,
                            s.processed_timestamp as store_processed_at
                        """,
            "alias": "s",
            "join_condition": "o.store_id = s.store_id"
        },
        {
            "table": "walmart.silver_tech.customers_t",
            "columns": """c.customer_id as customer_id,
                            c.first_name as customer_first_name,
                            c.last_name as customer_last_name,
                            c.email as customer_email,
                            c.phone as customer_phone_number,
                            c.city as customer_city,
                            c.province as customer_province,
                            c.country as customer_country,
                            c.created_timestamp as customer_created_timestamp,
                            c.updated_timestamp as customer_updated_timestamp,
                            c.is_active as customer_is_active,
                            c.processed_timestamp as customer_processed_at
                        """,
            "alias": "c",
            "join_condition": "o.customer_id = c.customer_id"
        },
        {
            "table": "walmart.silver_tech.employees_t",
            "columns": """e.employee_id as employee_id,
                            e.first_name as employee_first_name,
                            e.last_name as employee_last_name,
                            e.email as employee_email,
                            e.job_title as employee_job_title,
                            e.salary as employee_salary,
                            e.created_timestamp as employee_created_timestamp,
                            e.updated_timestamp as employee_updated_timestamp,
                            e.is_active as employee_is_active,
                            e.processed_timestamp as employee_processed_at
                        """,
            "alias": "e",
            "join_condition": "o.store_id = e.store_id"
        }

] %}

select 
    {% for config in configs %}
        {{ config.columns }}{% if not loop.last %},{% endif %}
    {% endfor %}
from 
    {%for config in configs %}
        {%if loop.first %}
            {{ config.table }} as {{ config.alias }}
        {%else%}
left join {{ config.table }} as {{ config.alias }}
            on {{ config.join_condition }}
        {%endif%}    
    {% endfor %}
  