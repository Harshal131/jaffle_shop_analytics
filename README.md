# Jaffle Shop Analytics

A local analytics engineering project built with **dbt Core** and **DuckDB** using the Jaffle Shop sample dataset. The goal of this project is to practice production-style dbt development locally, including source definitions, staging models, marts, data tests, snapshots, documentation, and Git-based workflow.

## Project overview

This project is designed as a learning-first but professionally structured dbt repository. It uses CSV seed files as raw input, transforms them through staged and business-facing models, and uses a dbt snapshot to preserve historical changes over time.

The project follows a layered dbt structure:

- **Seeds** for local raw input data
- **Staging** for cleaning and renaming source data
- **Intermediate** for reusable transformation logic
- **Marts** for business-facing datasets
- **Snapshots** for historical tracking
- **Tests** for data quality validation
- **Documentation** through YAML descriptions and dbt docs

## Tech stack

- **dbt Core**
- **dbt-duckdb**
- **DuckDB**
- **CSV seeds**
- **Git / GitHub**

DuckDB is used as the local development warehouse because it works well with dbt and persists data in a local `.duckdb` file, which makes it a good option for local learning and fast iteration.

## Project structure

```text
jaffle_shop_analytics/
├── analyses/
├── macros/
├── models/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
├── seeds/
├── snapshots/
├── tests/
├── dbt_project.yml
├── README.md
└── .gitignore
```

This structure follows common dbt best practices: staging models standardize raw inputs, intermediate models handle reusable business logic, and marts expose analytics-ready datasets.

## Dataset

This project uses the **Jaffle Shop** sample dataset.

Current seed files include:

- `raw_customers.csv`
- `raw_orders.csv`

These seeds are loaded into DuckDB with `dbt seed` and then transformed through the dbt model layers.

## Models

### Staging models

Staging models standardize raw inputs and create clean base tables for downstream transformations.

Examples:
- `stg_customers`
- `stg_orders`

Typical responsibilities in this layer:
- renaming columns,
- standardizing field names,
- casting data types,
- exposing clean keys for downstream use.

### Intermediate models

Intermediate models hold reusable transformation logic that sits between staging and marts.

Typical responsibilities in this layer:
- joins across staging models,
- reusable business logic,
- filtered or reshaped datasets used by multiple marts.

### Mart models

Mart models are business-facing datasets designed for analytics and reporting.

Examples may include:
- customer-order datasets,
- current-state datasets derived from snapshots,
- dimension and fact style models such as `dim_*` and `fct_*`.

This layer is intended to be the easiest layer for analysts or BI tools to query.

## Snapshot workflow

This project includes a dbt snapshot to track historical changes in order data over time.

The snapshot captures changes from a stable upstream model and stores row history using dbt’s snapshot metadata fields, such as:

- `dbt_valid_from`
- `dbt_valid_to`

This allows the project to preserve historical state instead of only keeping the latest version of a record.

A downstream model is also built from the snapshot to represent the current active state, typically by filtering for rows where:

```sql
dbt_valid_to is null
```

This creates a clean pattern of:

- **source / seed**
- **staging**
- **snapshot for history**
- **downstream current-state dataset for reporting**

## Data quality and testing

This project includes dbt tests to validate data quality at different layers.

Examples of implemented test types:
- `not_null`
- `unique`
- `relationships`
- singular SQL tests

Testing is applied where it makes the most sense:
- key integrity tests on staging models,
- business-facing contract tests on marts,
- snapshot-related validation where needed.

This reflects the dbt best practice that each layer should be tested according to its role in the pipeline.

## Documentation

The project includes documentation through YAML files for:

- sources,
- models,
- columns,
- tests.

This improves lineage, readability, and maintainability. Project documentation can be generated and viewed locally using dbt docs.

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

Set the DuckDB connection in `profiles.yml`.

Example:

```yaml
jaffle_shop_analytics:
  outputs:
    dev:
      type: duckdb
      path: 'C:/Users/<your-username>/.dbt/dev.duckdb'
      threads: 1

    prod:
      type: duckdb
      path: 'C:/Users/<your-username>/.dbt/prod.duckdb'
      threads: 4

  target: dev
```

Using an absolute path makes the local database file easier to find and inspect.

### 4. Load the seed data

```bash
dbt seed
```

### 5. Build the models

```bash
dbt run
```

### 6. Run the snapshot

```bash
dbt snapshot
```

### 7. Run tests

```bash
dbt test
```

### 8. Generate and serve documentation

```bash
dbt docs generate
dbt docs serve
```

## Example development workflow

When seed data changes, the normal local workflow is:

```bash
dbt seed
dbt run
dbt snapshot
dbt test
```

This ensures that:
- the raw CSV data is reloaded,
- models are rebuilt,
- historical changes are captured,
- and tests validate the final state.

## What this project demonstrates

This project is intended to demonstrate practical analytics engineering skills, including:

- local dbt development,
- DuckDB-based analytics workflows,
- layered dbt project design,
- source and model documentation,
- generic and singular data tests,
- snapshot-based historical tracking,
- downstream current-state modeling,
- Git-based version control.

## Future improvements

Planned next improvements include:

- expanding intermediate models,
- adding more business-facing marts,
- introducing `dim_*` and `fct_*` naming patterns more consistently,
- strengthening snapshot-specific validation,
- and adapting the same project structure to a cloud warehouse such as Snowflake.

## Notes

This repository is a learning project, but it is intentionally structured to reflect real dbt development practices. The focus is not only on getting SQL to run, but on building a maintainable, tested, documented analytics project end to end.