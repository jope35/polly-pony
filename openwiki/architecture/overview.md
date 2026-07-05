# Architecture overview

Polly-Pony separates Databricks resources into independent bundles that share configuration and a common Python utilities package. The design optimizes for **small deploy surfaces**, **scoped dependencies**, and **parallel validation/deploys**.

## High-level structure

```text
                    ┌─────────────────────────────────────┐
                    │         run-databricks-bundles.sh    │
                    │  (discover + parallel validate/deploy)│
                    └──────────────┬──────────────────────┘
                                   │
              ┌────────────────────┼────────────────────┐
              ▼                    ▼                    ▼
        ┌───────────┐        ┌───────────┐        ┌──────────────┐
        │  bundle/  │        │ bundle_a  │        │  bundle_b    │
        │ targets   │◄───────│ databricks│        │ databricks   │
        │ variables │◄───────│ .yml      │        │ .yml         │
        └───────────┘        └─────┬─────┘        └──────┬───────┘
                                   │                     │
                                   ▼                     ▼
                            Job (Python)          SDP Pipeline
                            seaborn plot          bronze→silver→gold
```

Both bundles **include** shared files from `bundle/`:

```yaml
include:
  - ../bundle/targets.yml
  - ../bundle/variables.yml
  - resources/*.yml
```

This keeps workspace hosts, catalog defaults, and target modes consistent while letting each bundle own its resources independently.

## Shared configuration (`bundle/`)

### Targets — [`bundle/targets.yml`](../../bundle/targets.yml)

| Target | Mode | Notes |
| --- | --- | --- |
| `dev` | `development` | Default target; `dynamic_version: true` on both artifacts |
| `prod` | `production` | Uses `root_path` under `/Workspace/Shared/.bundle/${bundle.name}/${bundle.target}` |

Both targets require a real `workspace.host` before deployment.

### Variables — [`bundle/variables.yml`](../../bundle/variables.yml)

| Variable | Default | Used by |
| --- | --- | --- |
| `root_catalog` | `workspace` | `bundle_b` pipeline catalog |
| `root_schema` | `default` | `bundle_b` pipeline schema |

Reference in bundle YAML as `${var.root_catalog}` and `${var.root_schema}`.

## Two-wheel artifact pattern

Every bundle's `databricks.yml` defines two wheel artifacts:

| Artifact | `path` | Build context | Output |
| --- | --- | --- | --- |
| `platform` | `.` (bundle dir) | `uv lock && uv build` inside bundle | Bundle-specific package wheel |
| `utils` | `..` (repo root) | `uv lock && uv build` at root | `polly-pony-utils` wheel |

Job and pipeline resource YAML reference wheels with globs relative to the resource file:

- `../dist/*.whl` — platform wheel built in the bundle directory
- `../../dist/*.whl` — utils wheel built at repo root

Example from [`bundle_a/resources/job_a.yml`](../../bundle_a/resources/job_a.yml):

```yaml
dependencies:
  - ../../dist/*.whl   # polly-pony-utils
  - ../dist/*.whl      # bundle-a package
```

## Shared Python package (`polly-pony-utils`)

Root package at [`src/polly_pony_utils/`](../../src/polly_pony_utils/):

| Module | Purpose |
| --- | --- |
| `logging.py` | `get_logger()` — consistent stdout logging for bundle code |
| `utils.py` | `hello()` — minimal example utility |
| `__init__.py` | Package exports |

Bundles depend on it via editable local source in each bundle's `pyproject.toml`:

```toml
[tool.uv.sources]
polly-pony-utils = { path = "..", editable = true }
```

**Rule of thumb**: shared cross-bundle logic goes in `polly-pony-utils`; bundle-specific logic stays in that bundle's `src/` tree.

## Bundle A — job with Python task

**Purpose**: Demonstrate a Databricks job running a Python entrypoint with seaborn visualization on sample NYC taxi data.

| Component | Path | Role |
| --- | --- | --- |
| Bundle config | [`bundle_a/databricks.yml`](../../bundle_a/databricks.yml) | Name, UUID, includes, artifacts |
| Job resource | [`bundle_a/resources/job_a.yml`](../../bundle_a/resources/job_a.yml) | `job_a` with `spark_python_task` |
| Entrypoint | [`bundle_a/src/main.py`](../../bundle_a/src/main.py) | Reads `samples.nyctaxi.trips`, calls `displot_sns` |
| Plot logic | [`bundle_a/src/bundle_a/plot.py`](../../bundle_a/src/bundle_a/plot.py) | Converts Spark DataFrame to pandas, renders seaborn displot |
| Dependencies | [`bundle_a/pyproject.toml`](../../bundle_a/pyproject.toml) | `seaborn>=0.13.2`, Python 3.12.3 |

The job uses Databricks environment spec version `"5"` with both wheel dependencies attached.

## Bundle B — SDP medallion pipeline

**Purpose**: Demonstrate a serverless Spark Declarative Pipeline with bronze / silver / gold layers on NYC taxi sample data.

| Layer | File | Output table/view |
| --- | --- | --- |
| Bronze | [`bundle_b/src/bronze.sql`](../../bundle_b/src/bronze.sql) | `bronze_nyctaxi_trips` (streaming from `samples.nyctaxi.trips`) |
| Silver | [`bundle_b/src/silver.py`](../../bundle_b/src/silver.py) | `silver_nyctaxi_trips` (filtered + hash-featurized `pickup_zip`) |
| Gold | [`bundle_b/src/gold.sql`](../../bundle_b/src/gold.sql) | `gold_nyctaxi_pickup_metrics` (aggregated metrics by hash buckets) |

Supporting code:

- [`bundle_b/src/bundle_b/featurize.py`](../../bundle_b/src/bundle_b/featurize.py) — `hash_featurize()` using `pmod(hash(col), num_features)` for categorical encoding.
- [`bundle_b/resources/pipeline_b.yml`](../../bundle_b/resources/pipeline_b.yml) — serverless pipeline config with `${var.root_catalog}` / `${var.root_schema}`.

Pipeline settings: `serverless: true`, `development: true`, `continuous: false`.

> **Naming note**: the pipeline resource name contains a `dlt`-style suffix for historical reasons; the implementation uses SDP medallion patterns.

## Development tooling

[`/.pre-commit-config.yaml`](../../.pre-commit-config.yaml) runs on commit:

- Standard hooks (trailing whitespace, YAML/TOML checks, no direct commits to `main`)
- **ruff** organize-imports, format, and lint via `uv run --group dev`
- **uv audit** on root, `bundle_a`, and `bundle_b` when lockfiles change

Run locally from repo root:

```bash
uv run --group dev pre-commit run --all-files
```

## Why split bundles?

| Benefit | How Polly-Pony achieves it |
| --- | --- |
| Decoupled resources | Job and pipeline deploy independently |
| Scoped dependencies | Each bundle has its own `pyproject.toml` and `uv.lock` |
| Smaller deploy surfaces | Change one bundle without touching unrelated resources |
| Parallel operations | `run-databricks-bundles.sh` validates/deploys all bundles concurrently |

## Extension points for agents

1. **New bundle**: Create `bundle_c/` at repo root with `databricks.yml`, `pyproject.toml`, `resources/`, and `src/`. Include shared `bundle/*.yml` files. The runner will auto-discover it.
2. **New shared utility**: Add to `src/polly_pony_utils/` and export from `__init__.py` if needed.
3. **New pipeline layer**: Add SQL or Python files under `bundle_b/src/` and register in `pipeline_b.yml` libraries.
4. **New job task**: Extend `bundle_a/resources/job_a.yml` or add tasks in a new resource file under `resources/`.

## Related pages

- [Quickstart](../quickstart.md)
- [Deployment workflows](../workflows/deployment.md)
