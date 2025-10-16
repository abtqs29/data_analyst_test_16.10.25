-- Month-over-month revenue growth
with monthly as (
    select
        date_trunc('month', order_datetime_kyiv)::date as month,
        sum(company_revenue) as revenue
    from {{ ref('fct_sales') }}
    group by 1
)
select
    month,
    revenue,
    lag(revenue) over (order by month) as prev_month_revenue,
    case
        when lag(revenue) over (order by month) = 0 then null
        else round( (revenue - lag(revenue) over (order by month)) / nullif(lag(revenue) over (order by month), 0) * 100, 2)
    end as revenue_growth_pct
from monthly
order by month;