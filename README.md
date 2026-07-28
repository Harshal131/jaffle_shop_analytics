# Jaffle Shop Analytics

A local **dbt Core + DuckDB** analytics project built for learning modern analytics engineering workflows using the Jaffle Shop sample dataset.[1][2]

## Project goal

This project is designed to practice the full dbt workflow locally before moving to a cloud warehouse like Snowflake. It covers seeded raw data, staging models, marts, tests, and documentation in a version-controlled project structure.[1][3][4]

## Tech stack

- dbt Core
- DuckDB
- CSV seeds
- Git/GitHub

DuckDB is a good local starting point because dbt supports it as a local data platform and it can persist data in a local `.duckdb` file.[1][3]

## Current project structure

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

This layered structure follows common dbt project organization, where staging handles cleanup, intermediate handles transformation steps, and marts expose business-facing models.[4][5][6]

## Dataset

This project uses the Jaffle Shop sample dataset, which is commonly used to learn dbt and includes seed-style CSV data for entities such as customers and orders.[2][7][8]

Current local seed files:
- `raw_customers.csv`
- `raw_orders.csv`

## Models built

### Staging

- `stg_customers`: renames raw customer fields into clearer analytics-friendly names.[9][10]
- `stg_orders`: renames raw order fields and standardizes keys for downstream joins.[9][10]

### Mart

- `customers_orders`: combines customers and orders into a business-facing mart for simple customer-order analysis.[6][11]

## Tests implemented

This project includes both generic and singular dbt tests.

Generic tests currently cover:
- `not_null` on customer and order identifiers.[12][13]
- `unique` on `stg_orders.order_id`.[12][13]
- `relationships` between `customers_orders.customer_id` and `stg_customers.customer_id`.[12][14]

A singular test is also used for a simple data quality sanity check, which follows dbt’s pattern that a singular test should return only failing rows.[13][15]

## Sources and documentation

The project documents raw input data using `sources:` definitions and adds model and column descriptions in YAML files. This makes lineage clearer and helps future collaborators understand where data comes from and what each field means.[16][17]

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

Set the DuckDB connection in `profiles.yml` under the local `.dbt` folder. In dbt, connection details such as `target`, `outputs`, `type`, and `path` belong in `profiles.yml`, not in `dbt_project.yml`.[18][1]

Example:

```yaml
jaffle_shop_analytics:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: 'jaffle_shop.duckdb'
      threads: 4
```

### 4. Load seed data

```bash
dbt seed
```

`dbt seed` loads static CSV files from the project’s seed paths into the target warehouse as tables.[19][20]

### 5. Build models

```bash
dbt run
```

### 6. Run tests

```bash
dbt test
```

### 7. Generate docs

```bash
dbt docs generate
dbt docs serve
```

## Learning outcomes

This project is intended to build practical skill in:
- local dbt development,
- layered modeling with staging and marts,
- source documentation,
- generic and singular tests,
- Git-based analytics engineering workflow.[3][4][16]

## Next improvements

Planned next steps include:
- adding intermediate models,
- creating more realistic mart patterns such as `dim_customers` and `fct_orders`,
- expanding tests,
- and later adapting the same dbt structure to Snowflake.[5][21][22]