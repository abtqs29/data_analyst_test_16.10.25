# GYB Test Assignment — dbt Project (PostgreSQL)

This repo contains a ready-to-run dbt project for the GYB test task.

## Stack
- Database: **PostgreSQL**
- Tooling: **dbt-core** + **dbt-postgres**

## Quickstart

1. **Install dbt for Postgres**
   ```bash
   pip install dbt-postgres
   ```

2. **Create or edit `~/.dbt/profiles.yml`** (see sample below) to point to your PostgreSQL:
   ```yaml
   gyb_test_project:
     target: dev
     outputs:
       dev:
         type: postgres
         host: localhost
         user: your_user
         password: your_password
         port: 5432
         dbname: your_database
         schema: public
   ```

3. **Seed the data** (this loads `seeds/sales_data.csv` into your DB):
   ```bash
   dbt seed
   ```

4. **Build models** (creates staging + marts, including `fct_sales`):
   ```bash
   dbt run
   ```

5. **Run tests**:
   ```bash
   dbt test
   ```

6. **Open and run analyses** (in your SQL editor or dbt Cloud UI):
   - `analyses/revenue_growth.sql`
   - `analyses/agent_performance.sql`
   - `analyses/discount_analysis.sql`

> Converted 'Sales Data.xlsx' to seeds/sales_data.csv

---

## Files of interest

- `models/staging/stg_sales.sql` – cleans and casts the seed data (fills missing with 'N/A').
- `models/marts/fct_sales.sql` – the fact table with revenue logic, 3 timezones, and refund day difference.
- `analyses/` – three analysis queries as required.
- `tests/schema.yml` – basic data validity tests (core).

## Notes
- Missing values are filled with `'N/A'` per task note.
- Timezone conversions use `Europe/Kyiv` and `America/New_York` (PostgreSQL).