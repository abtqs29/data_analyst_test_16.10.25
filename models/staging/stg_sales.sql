{{ config(materialized='view', schema='staging') }}

with raw as (

  select
      coalesce("Reference ID"::varchar, 'N/A')              as reference_id,
      coalesce("Country"::varchar, 'N/A')                   as country,
      coalesce("Product Code"::varchar, 'N/A')              as product_code,
      coalesce("Product Name"::varchar, 'N/A')              as product_name,
      coalesce("Sales Agent Name"::varchar, 'N/A')          as sales_agent_name,
      coalesce("Campaign Name"::varchar, 'N/A')             as campaign_name,
      coalesce("Source"::varchar, 'N/A')                    as source,

      /* числові */
      coalesce("Total Amount ($)"::numeric, 0)              as total_amount,
      coalesce("Discount Amount ($)"::numeric, 0)           as discount_amount,
      coalesce("Returned Amount ($)"::numeric, 0)               as returned_amount,
      coalesce("Number Of Rebills"::int, 0)                 as number_of_rebills,
      coalesce("Original Amount ($)"::numeric, 0)               as original_amount,
      coalesce("Total Rebill Amount"::numeric, 0)           as total_rebill_amount,

      /* дати (у seed — без TZ) => приводимо до timestamptz */
      case when "Order Date Kyiv"  is null then null else "Order Date Kyiv"::timestamptz  end as order_date_kyiv_ts,
      case when "Return Date Kyiv" is null then null else "Return Date Kyiv"::timestamptz end as return_date_kyiv_ts,
      case when "Last Rebill Date Kyiv" is null then null else "Last Rebill Date Kyiv"::timestamptz end as last_rebill_date_kyiv_ts,

      /* текст Yes/No -> boolean */
      (lower(coalesce("Has Chargeback",'no')) = 'yes')      as has_chargeback,
      (lower(coalesce("Has Refund",'no')) = 'yes')          as has_refund

  from {{ ref('sales_data') }}

)

select * from raw
