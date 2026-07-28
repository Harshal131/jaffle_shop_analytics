select 1 as failure
where not exists (
    select 1
    from {{ ref('customers_orders') }}
)