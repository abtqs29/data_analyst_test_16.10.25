-- Agent performance: avg revenue, sales count, avg discount, ranking by total revenue
with exploded as (
    select
        reference_id,
        regexp_split_to_table(agent_names, '\s*,\s*') as agent_name,
        company_revenue,
        discount_amount
    from {{ ref('fct_sales') }}
)
select
    agent_name,
    count(distinct reference_id) as total_sales,
    round(avg(company_revenue), 2) as avg_revenue,
    round(avg(discount_amount), 2) as avg_discount,
    round(sum(company_revenue), 2) as total_revenue,
    rank() over (order by sum(company_revenue) desc) as revenue_rank
from exploded
group by agent_name
order by revenue_rank, agent_name;