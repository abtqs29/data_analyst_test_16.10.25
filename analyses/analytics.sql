-- Аналіз продажів на основі моделі fct_sales
-- ==========================================

-- 1️⃣ Загальний дохід
select
    sum(total_revenue) as total_revenue_usd,
    sum(rebill_revenue) as total_rebill_revenue_usd,
    sum(returned_amount) as total_refunded_usd
from {{ ref('fct_sales') }};

-- 2️⃣ Дохід за країнами
select
    country,
    round(sum(total_revenue), 2) as total_revenue,
    round(sum(rebill_revenue), 2) as rebill_revenue,
    round(sum(returned_amount), 2) as refunded
from {{ ref('fct_sales') }}
group by country
order by total_revenue desc;

-- 3️⃣ Середня знижка та середня кількість ребілів
select
    avg(discount_amount) as avg_discount,
    avg(number_of_rebills) as avg_rebills
from {{ ref('fct_sales') }};

-- 4️⃣ Топ-5 агентів за продажами
select
    sales_agent_name,
    round(sum(total_revenue), 2) as revenue
from {{ ref('fct_sales') }}
group by sales_agent_name
order by revenue desc
limit 5;

-- 5️⃣ Середня затримка повернення
select
    avg(refund_delay_days) as avg_refund_delay_days
from {{ ref('fct_sales') }}
where refund_delay_days is not null;
