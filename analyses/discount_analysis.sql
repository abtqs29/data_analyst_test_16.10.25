-- Agents whose average discounts are above overall average
with exploded as (
    select
        reference_id,
        regexp_split_to_table(agent_names, '\s*,\s*') as agent_name,
        discount_amount
    from {{ ref('fct_sales') }}
),
overall as (
    select avg(discount_amount) as avg_discount_all from {{ ref('fct_sales') }}
)
select
    e.agent_name,
    round(avg(e.discount_amount), 2) as avg_discount
from exploded e, overall o
group by e.agent_name, o.avg_discount_all
having avg(e.discount_amount) > o.avg_discount_all
order by avg_discount desc;