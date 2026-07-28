{{ config(materialized='table') }}

select *
 from {{ ref('orders_snapshot') }}
 where dbt_valid_to is null