# Jaffle Shop Analytics

A local dbt Core + DuckDB analytics project built to practice modern analytics engineering workflows using the Jaffle Shop sample dataset.

## Project goal

This project is designed to practice the full dbt workflow locally before moving to a cloud warehouse like Snowflake. It includes seeded raw data, staging models, marts, tests, snapshots, and documentation in a version-controlled project structure.

## Tech stack

- dbt Core
- DuckDB
- CSV seeds
- Git / GitHub

DuckDB is a good local starting point because it works well with dbt and persists data in a local `.duckdb` file.

## Project structure

```text
jaffle_shop_analytics/
├── models/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
├── seeds/
├── tests/
├── macros/
├── snapshots/
├── analyses/
├── dbt_project.yml
├── README.md
└── .gitignore
```

This layered structure follows common dbt organization: staging cleans and standardizes data, intermediate models handle transformation logic, and marts expose business-facing outputs.

## Dataset

This project uses the Jaffle Shop sample dataset, which is commonly used to learn dbt and includes seed-style CSV data for entities such as customers and orders.

Current seed files:
- `raw_customers.csv`
- `raw_orders.csv`

## Models

### Staging

- `stg_customers`: renames raw customer fields into cleaner analytics-friendly names.
- `stg_orders`: renames raw order fields and standardizes keys for downstream joins.

### Mart

- `customers_orders`: combines customers and orders into a business-facing mart for customer-order analysis.

## Snapshot

A dbt snapshot is used to track changes in the orders data over time. This allows the project to preserve history instead of only storing the latest value.

## Tests

This project includes both generic and singular dbt tests.

Generic tests currently cover:
- `not_null` on customer and order identifiers.
- `unique` on `stg_orders.order_id`.
- `relationships` between `customers_orders.customer_id` and `stg_customers.customer_id`.

A singular test is also used for a simple data quality sanity check. Singular tests should return only failing rows.

## Sources and documentation

The project documents raw input data using `sources:` definitions and adds model and column descriptions in YAML files. This makes lineage clearer and helps future contributors understand where data comes from and what each field means.

## How to run locally

### 1. Create and activate a virtual environment

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
```

### 2. Install dependencies

```bash
pip install --upgrade pip
pip install dbt-core dbt-duckdb
dbt --version
```

### 3. Configure the dbt profile

Set the DuckDB connection in `profiles.yml` under the local `.dbt` folder.

Example:

```yaml
jaffle_shop_analytics:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: 'C:/Users/vakha/.dbt/dev.duckdb'
      threads: 1
```

### 4. Load seed data

```bash
dbt seed
```

### 5. Build models

```bash
dbt run
```

### 6. Run snapshots

```bash
dbt snapshot
```

### 7. Run tests

```bash
dbt test
```

### 8. Generate docs

```bash
dbt docs generate
dbt docs serve
```

## What’s implemented

- Local dbt Core + DuckDB setup
- Seeded source data
- Staging models
- Business-facing mart model
- Snapshot history tracking
- Generic and singular tests
- Source and model documentation

## Next improvements

Planned next steps include:
- adding intermediate models,
- creating more realistic mart patterns such as `dim_customers` and `fct_orders`,
- expanding tests,
- and later adapting the same dbt structure to Snowflake.