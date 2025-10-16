{{ config(materialized='view', schema='marts') }}

with fct as (
  select
      reference_id,
      country,
      product_name,
      sales_agent_name,
      campaign_name,
      source,
      total_amount,
      discount_amount,
      returned_amount,
      total_rebill_amount,
      number_of_rebills,
      original_amount,
      (coalesce(total_amount, 0)
       + coalesce(total_rebill_amount, 0)
       - coalesce(returned_amount, 0)) as total_revenue,
      coalesce(total_rebill_amount, 0) as rebill_revenue,
      order_date_kyiv_ts,
      (order_date_kyiv_ts at time zone 'UTC') as order_date_utc,
      (order_date_kyiv_ts at time zone 'America/New_York') as order_date_ny,
      return_date_kyiv_ts,
      (return_date_kyiv_ts at time zone 'UTC') as return_date_utc,
      (return_date_kyiv_ts at time zone 'America/New_York') as return_date_ny,
      case
        when return_date_kyiv_ts is not null and order_date_kyiv_ts is not null
          then date_part('day', return_date_kyiv_ts - order_date_kyiv_ts)
        else null
      end as refund_delay_days,
      has_chargeback,
      has_refund
  from {{ ref('stg_sales') }}
)

-- прибираємо дублікати за reference_id
select *
from (
  select *,
         row_number() over (
           partition by reference_id
           order by order_date_kyiv_ts desc nulls last
         ) as rn
  from fct
) deduped
where rn = 1
