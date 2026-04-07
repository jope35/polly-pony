<br />
<h1 style="font-size: 6em;"><p align="center">🐎🐎🐎 Polly-Pony 🐎🐎🐎</p></h1>
<h2><p align="center">Supercharge your Databricks bundle deployments</p></h2>
<h3><p align="center">A lightweight pattern for splitting and deploying independent Databricks bundles</p></h3>

<p align="center">
  <a href="https://www.python.org/">
    <img alt="Python 3.12.3" src="https://img.shields.io/badge/Python-3.12.3-blue.svg" />
  </a>
  <a href="https://github.com/astral-sh/uv">
    <img alt="uv" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/uv/main/assets/badge/v0.json" />
  </a>
  <a href="https://pre-commit.com/">
    <img alt="pre-commit" src="https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=yellow" />
  </a>
  <a href="https://docs.astral.sh/ruff/">
    <img alt="Ruff" src="https://img.shields.io/badge/Ruff-%3E%3D0.15.7-563D7C?logo=ruff&logoColor=white" />
  </a>
  <a href="https://docs.databricks.com/en/dev-tools/bundles/index.html">
    <img alt="Declarative Automation Bundles" src="https://img.shields.io/badge/Declarative%20Automation-Bundles-ff3621.svg" />
  </a>
  <a href="https://github.com/revodatanl/polly-pony/blob/main/LICENSE">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="https://github.com/revodatanl/polly-pony/commits/main">
    <img alt="GitHub last commit (branch)" src="https://img.shields.io/github/last-commit/revodatanl/polly-pony/main" />
  </a>
</p>
<br />

# What is Polly-Pony?

Polly-Pony is a small, opinionated example of deploying Databricks resources through **multiple independent [Databricks Asset Bundles](https://docs.databricks.com/en/dev-tools/bundles/index.html)** (formerly known as Declarative Automation Bundles).

Each bundle is its own deployable unit (`bundle_a`, `bundle_b` here) with a dedicated `databricks.yml`, artifact builds, and lifecycle. A root script discovers those bundles and can **validate**, **deploy**, or **destroy** them **in parallel**.

# Highlights

- 🗂️ **Multi-bundle layout**: one `databricks.yml` per bundle; shared targets and variables under `bundle/`.
- 🐍 **Shared Python package**: `polly-pony-utils` at the repo root (`src/polly_pony_utils`).
- 🛞🛞 **Two-wheel artifact pattern** per bundle: a **platform** wheel (bundle code) plus a **utils** wheel (shared package).
- ⚡ **Parallel workflow**: `run-databricks-bundles.sh` runs each bundle concurrently with prefixed logs.
- 📌 **Pinned Python**: root and bundle projects use **Python 3.12.3** in their `pyproject.toml` files.

---

- [What is Polly-Pony?](#what-is-polly-pony)
- [Highlights](#highlights)
- [Prerequisites](#prerequisites)
- [Repository structure](#repository-structure)
- [Configuration](#configuration)
- [Quickstart](#quickstart)
- [How deployments work](#how-deployments-work)
- [Why split bundles?](#why-split-bundles)
- [Example bundles](#example-bundles)
- [Artifact pattern](#artifact-pattern)
- [Dependency management](#dependency-management)
  - [Decision tree: where to declare a dependency](#decision-tree-where-to-declare-a-dependency)
- [Troubleshooting](#troubleshooting)
- [License](#license)


# Prerequisites

- **[Databricks CLI](https://docs.databricks.com/en/dev-tools/cli/index.html)** installed and **authenticated** against the workspace you intend to use.
- **Python 3**
- **[uv](https://github.com/astral-sh/uv)** (used in bundle artifact `build` steps).


# Repository structure

```text
.
├── run-databricks-bundles.sh       # validate / deploy / destroy all discovered bundles in parallel
├── pyproject.toml                  # polly-pony-utils (shared package)
├── src/polly_pony_utils/           # shared utility package source
├── bundle/                         # shared targets + variables included by each bundle
│   ├── targets.yml
│   └── variables.yml
├── bundle_a/                       # example: job bundle (seaborn visualization task)
│   ├── databricks.yml
│   ├── pyproject.toml
│   ├── resources/
│   └── src/
└── bundle_b/                       # example: SDP medallion-style pipeline bundle
    ├── databricks.yml
    ├── pyproject.toml
    ├── resources/
    └── src/
```
# Configuration

Before you deploy, adjust shared bundle inputs to match **your** workspace and catalog defaults.

| File                                           | Role                                                                                                                                         |
| ---------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| [`bundle/targets.yml`](bundle/targets.yml)     | Named targets (for example `dev`, `prod`) and `workspace.host` per target. **Replace the example hosts** with your Databricks workspace URL. |
| [`bundle/variables.yml`](bundle/variables.yml) | Bundle variables such as `root_catalog` and `root_schema`.                                                                                   |

Each bundle’s `databricks.yml` **includes** these files so targets and variables stay consistent across bundles.

# Quickstart

From the repository root:

```bash
# Discover bundles, validate all (no deploy)
./run-databricks-bundles.sh --validate-only

# Validate and deploy all bundles to the default target (see bundle/targets.yml)
./run-databricks-bundles.sh

# Deploy all bundles to a specific named target
./run-databricks-bundles.sh --target prod

# Help (lists -t/--target, -v/--validate-only, -d/--destroy-only)
./run-databricks-bundles.sh --help

# Destroy all bundles on the given target (use with care)
# Destroys resources for ALL discovered bundles on the given target, with --auto-approve
./run-databricks-bundles.sh --destroy-only --target dev
```

**Single bundle:**


```bash
cd bundle_a
databricks bundle validate
databricks bundle deploy
# Optional: pass the same target as in bundle/targets.yml
# databricks bundle validate -t dev
# databricks bundle deploy -t dev
```

# How deployments work

[`run-databricks-bundles.sh`](run-databricks-bundles.sh) discovers bundle directories by running `find` with **`-maxdepth 2`** for `databricks.yml` under the repo root. Only layouts like `./bundle_a/databricks.yml` are picked up; deeper paths are **not** discovered by this script.

For each bundle directory it:

| Mode              | Script flags      | Per bundle                                                   |
| ----------------- | ----------------- | ------------------------------------------------------------ |
| Validate only     | `--validate-only` | `databricks bundle validate`                                 |
| Validate + deploy | *(default)*       | `databricks bundle validate` then `databricks bundle deploy` |
| Destroy only      | `--destroy-only`  | `databricks bundle destroy --auto-approve`                   |

When a `--target` / `-t` is passed to the script, it is forwarded to the Databricks CLI as `-t` for each command.

Jobs run **in parallel** (background subshells); output lines are prefixed by bundle name and color-coded. The script exits non-zero if any bundle fails, and prints a short summary of failed bundle names.



# Why split bundles?

Splitting work across multiple bundles tends to:

- decoupled **resources** (for example, a standalone job bundle vs a pipeline bundle),
- improve **separation of concerns for Python dependencies** (each bundle has its own `pyproject.toml` and lockfile, so pins, upgrades, and extra libraries stay scoped to that bundle’s code and don’t pull unrelated stacks along),
- keep **deploy surfaces smaller** (change one bundle without touching unrelated resources),
- allow **parallel validation and deploys** (as this repo demonstrates).

Databricks documents bundle concepts and workflow in the **[Bundles developer guide](https://docs.databricks.com/en/dev-tools/bundles/index.html)**.

# Example bundles

- **`bundle_a`**: a **job** with a Python task that runs [`bundle_a/src/main.py`](bundle_a/src/main.py). In [`bundle_a/resources/job_a.yml`](bundle_a/resources/job_a.yml), dependency paths are relative to that file: `../dist/*.whl` is **bundle_a**’s wheel output and `../../dist/*.whl` is the **repo root** (shared utils) wheel output.

- **`bundle_b`**: a **serverless pipeline** wired to [`bundle_b/src/bronze.sql`](bundle_b/src/bronze.sql), [`bundle_b/src/silver.py`](bundle_b/src/silver.py), and [`bundle_b/src/gold.sql`](bundle_b/src/gold.sql). Catalog and schema come from `${var.root_catalog}` and `${var.root_schema}`. Library dependencies use the same `dist/*.whl` pattern. See [`bundle_b/resources/pipeline_b.yml`](bundle_b/resources/pipeline_b.yml).

> **Naming note:** the pipeline’s default `name` in YAML may contain a `dlt`-style suffix for historical reasons; assets here are structured as a **medallion (bronze / silver / gold)** flow consistent with **Spark Declarative Pipelines (SDP)**.

# Artifact pattern

Every bundle defines **two** wheel artifacts in its `databricks.yml`:

| Artifact   | `path`                 | Built as              | Meaning                                |
| ---------- | ---------------------- | --------------------- | -------------------------------------- |
| `platform` | `.` (bundle directory) | `uv lock && uv build` | Wheel for that bundle’s Python package |
| `utils`    | `..` (repo root)       | `uv lock && uv build` | Wheel for `polly-pony-utils`           |

Because `utils` uses `path: ..`, its build command runs with the **repo root** as the build context for that artifact; `platform` builds **inside the bundle directory**. Bundle deploys expect the resulting wheels under each project’s `dist/` (and your job/pipeline configs reference those globs).

# Dependency management

Each bundle depends on `polly-pony-utils` via local editable source mapping in the bundle’s `pyproject.toml`:

```toml
[tool.uv.sources]
polly-pony-utils = { path = "..", editable = true }
```

## Decision tree: where to declare a dependency

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

# Troubleshooting

- **“No databricks.yml files found”**: the script only searches up to **depth 2** from the repo root. Move bundles accordingly, or adjust the script if you need a deeper layout.
- **Authentication / permission errors**: confirm `databricks auth` (or your org’s SSO/profile setup) and that your user can deploy to the workspace in `bundle/targets.yml`.
- **Missing wheels / dependency resolution in jobs or pipelines**: run a validate or deploy so artifact builds run; ensure `uv` is available on the machine running the CLI. Check that `dist/*.whl` paths referenced in resource YAML match where your builds output wheels.
- **Wrong workspace**: the example `workspace.host` values in [`bundle/targets.yml`](bundle/targets.yml) are placeholders for this repo—**you must update them** for your environment.

# License

This project is licensed under the MIT License—see [`LICENSE`](LICENSE).
