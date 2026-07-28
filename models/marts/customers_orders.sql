{{ config(materialized='table') }}
with customers as (
    select
        *
    from {{ ref('stg_customers') }}
),
orders as (
    select
        *
    from {{ ref('stg_orders') }}
),
customer_orders as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        o.order_id,
        o.order_date,
        o.status
    from customers c
    left join orders o
    on c.customer_id = o.customer_id
)
select * from customer_orders