{% snapshot orders_snapshot %}

    {{ config(target_schema='main',
                unique_key='order_id',
                strategy='check',   
                check_cols=['status']

    ) }}

    select order_id, 
           customer_id, 
           order_date, 
           status
    from {{ ref('stg_orders') }}

{% endsnapshot %}