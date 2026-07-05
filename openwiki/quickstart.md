# Polly-Pony quickstart

Polly-Pony is a small, opinionated example of deploying Databricks resources through **multiple independent [Declarative Automation Bundles](https://docs.databricks.com/en/dev-tools/bundles/index.html)** (DAB). Each bundle is its own deployable unit with a dedicated `databricks.yml`, wheel artifacts, and lifecycle. A root script discovers bundles and can **validate**, **deploy**, or **destroy** them **in parallel**.

This OpenWiki is agent-oriented documentation: start here before exploring source files.

## What this repository does

- Demonstrates a **multi-bundle Databricks layout** with shared configuration under `bundle/`.
- Ships a shared Python package **`polly-pony-utils`** at the repo root (`src/polly_pony_utils`).
- Builds **two wheels per bundle**: a **platform** wheel (bundle code) and a **utils** wheel (shared package).
- Orchestrates bundle lifecycle through [`run-databricks-bundles.sh`](../run-databricks-bundles.sh).
- Includes two example bundles:
  - **`bundle_a`**: a Databricks job with a Python task (seaborn visualization).
  - **`bundle_b`**: a serverless Spark Declarative Pipeline (SDP) with bronze / silver / gold medallion layers.

## Prerequisites

| Tool | Purpose |
| --- | --- |
| [Databricks CLI](https://docs.databricks.com/en/dev-tools/cli/index.html) | Authenticated against your target workspace |
| Python 3 | Local development and pre-commit hooks |
| [uv](https://github.com/astral-sh/uv) | Wheel builds in bundle artifact steps |

Before deploying, update [`bundle/targets.yml`](../bundle/targets.yml) with your workspace host and adjust [`bundle/variables.yml`](../bundle/variables.yml) for your Unity Catalog defaults.

## Start here

- [Architecture overview](./architecture/overview.md) — repository layout, bundle structure, artifact pattern, and shared utilities.
- [Deployment workflows](./workflows/deployment.md) — validate, deploy, destroy, and single-bundle commands.

## Repository layout

```text
.
├── run-databricks-bundles.sh   # validate / deploy / destroy all bundles in parallel
├── pyproject.toml              # polly-pony-utils (shared package)
├── src/polly_pony_utils/       # shared utility package source
├── bundle/                     # shared targets + variables included by each bundle
│   ├── targets.yml
│   └── variables.yml
├── bundle_a/                   # example: job bundle (seaborn visualization task)
│   ├── databricks.yml
│   ├── pyproject.toml
│   ├── resources/job_a.yml
│   └── src/
└── bundle_b/                   # example: SDP medallion-style pipeline bundle
    ├── databricks.yml
    ├── pyproject.toml
    ├── resources/pipeline_b.yml
    └── src/
```

## Common agent tasks

| Task | Where to start | Key files |
| --- | --- | --- |
| Add a new bundle | Copy `bundle_a` or `bundle_b` pattern; place `databricks.yml` at depth ≤ 2 from repo root | New `bundle_*/databricks.yml`, `bundle/*/yml` includes |
| Add a shared utility | Root `pyproject.toml` + `src/polly_pony_utils/` | Consumed transitively by bundles via `[tool.uv.sources]` |
| Add a bundle-specific dependency | That bundle's `pyproject.toml` | Run `uv lock` in the bundle directory |
| Change deployment targets | `bundle/targets.yml` | Shared across all bundles via `include` |
| Change UC catalog/schema defaults | `bundle/variables.yml` | Referenced as `${var.root_catalog}` / `${var.root_schema}` |
| Run all bundles locally | `./run-databricks-bundles.sh --validate-only` | See [deployment workflows](./workflows/deployment.md) |

## Dependency decision tree

```text
Do I need a new Python package?
│
├─ YES: Is it used by polly-pony-utils?
│       │
│       ├─ YES: Declare it in root pyproject.toml (polly-pony-utils)
│       │       and let bundles receive it transitively.
│       │
│       └─ NO: Is it bundle-specific?
│               │
│               ├─ YES: Declare it in that bundle's pyproject.toml.
│               │
│               └─ NO: If several bundles need it, keep version
│                       ranges aligned across those bundles.
│
└─ NO: Nothing to do.
```

## Abbreviations

| Term | Meaning |
| --- | --- |
| DAB | Declarative Automation Bundles |
| SDP | Spark Declarative Pipeline (formerly DLT / Delta Live Tables) |
| UC | Unity Catalog |

## Key source files

- [`README.md`](../README.md) — human-facing project overview and troubleshooting.
- [`run-databricks-bundles.sh`](../run-databricks-bundles.sh) — parallel bundle discovery and lifecycle orchestration.
- [`bundle/targets.yml`](../bundle/targets.yml) — shared deployment targets (`dev`, `prod`).
- [`bundle/variables.yml`](../bundle/variables.yml) — shared bundle variables (`root_catalog`, `root_schema`).
- [`bundle_a/databricks.yml`](../bundle_a/databricks.yml) — job bundle definition and artifacts.
- [`bundle_b/databricks.yml`](../bundle_b/databricks.yml) — pipeline bundle definition and artifacts.
- [`.pre-commit-config.yaml`](../.pre-commit-config.yaml) — ruff formatting/linting and `uv audit` on lockfile changes.

## Notes for future agents

- **Bundle discovery is shallow**: `run-databricks-bundles.sh` only finds `databricks.yml` files up to **depth 2** from the repo root. New bundles must follow `./bundle_x/databricks.yml`, not deeper nesting.
- **Python version is pinned**: root and both bundles require **Python 3.12.3** in their `pyproject.toml` files — keep them aligned.
- **Wheel paths in resource YAML are relative** to the resource file: `../dist/*.whl` is the bundle wheel; `../../dist/*.whl` is the repo-root utils wheel.
- **Do not commit secrets**: workspace hosts in `targets.yml` are placeholders (`<<FILL IN YOUR HOST>>`); never document or commit real credentials.
- **Human README vs OpenWiki**: [`README.md`](../README.md) is the polished user guide; this OpenWiki focuses on how agents should navigate and change the repo safely.

## Documentation map

- [Architecture](./architecture/overview.md)
- [Deployment workflows](./workflows/deployment.md)
