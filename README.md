<br />
<h1 style="font-size: 6em;"><p align="center">🐎🐎🐎 Polly-Pony 🐎🐎🐎</p></h1>
<h2><p align="center">Supercharge your Databricks bundle deployments</p></h2>
<h3><p align="center">A lightweight pattern for splitting and deploying independent Databricks bundles</p></h3>

<p align="center">
  <a href="https://www.python.org/">
    <img alt="Python >=3.12" src="https://img.shields.io/badge/Python-%3E%3D3.12-blue.svg" />
  </a>
  <a href="https://github.com/astral-sh/uv">
    <img alt="uv" src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/uv/main/assets/badge/v0.json" />
  </a>
  <a href="https://docs.databricks.com/en/dev-tools/bundles/index.html">
    <img alt="Declarative Automation Bundles" src="https://img.shields.io/badge/Declarative%20Automation-Bundles-ff3621.svg" />
  </a>
  <a href="https://github.com/revodatanl/polly-pony/commits/main">
    <img alt="GitHub last commit (branch)" src="https://img.shields.io/github/last-commit/revodatanl/polly-pony/main" />
  </a>
</p>
<br />

# Welcome

Polly-Pony is a (lightly) opinionated setup for deploying Databricks resources through multiple independent Declarative Automation Bundles.
This repository demonstrates how to split one large deployment into smaller, isolated bundle units that can be validated and deployed in parallel.

# Highlights

- **Multi-bundle layout**: each bundle component has its own `databricks.yml`, leading to a clean and modular deployment structure.
- **Shared code package**: common utilities are published from the root package.
- **Two-wheel artifact pattern** per bundle: each deployment builds both a bundle wheel and the shared utils wheel.
- **Parallel deployment workflow** across all discovered bundles.
- **Consistent Python baseline** across root and bundle projects (Python 3.12.3, Databricks Runtime 17.3 LTS).

# Repository Structure

```text
.
├── run-databricks-bundles.sh       # deployment script for all bundles
├── pyproject.toml                  # Python project config for the shared polly-pony-utils package
├── src/polly_pony_utils/           # Source code for the shared utility package
├── bundle/                         # Root configuration for bundle variables and targets
│    ├── targets.yml                # deploy targets (e.g., dev, prod, etc.)
│    └── variables.yml              # global variables for bundle deployments
├── bundle_a/                       # independent bundle: seaborn visualization job
│   ├── databricks.yml              # deployment configuration
│   ├── pyproject.toml              # Python project config
│   └── src/                        # bundle source code
└── bundle_b/                       # independent bundle: SDP medallion pipeline
    ├── databricks.yml              # deployment configuration
    ├── pyproject.toml              # Python project config
    └── src/                        # bundle source code
```

# Why Split a Bundle?

Databricks Asset Bundles use Terraform state under the hood. Splitting resources into multiple bundles reduces coupling and enables separate deployment lanes.

In this repo, each bundle is a standalone deployment unit: `bundle_a` and `bundle_b`.
Each has:

- its own `databricks.yml`
- its own artifact build definitions
- its own deployment lifecycle

This setup makes it practical to validate/deploy bundle changes independently instead of routing everything through one large state.

# How Deployments Work

`run-databricks-bundles.sh` auto-discovers directories containing `databricks.yml` (within repo depth), then runs:

1. `databricks bundle validate`
2. `databricks bundle deploy` (unless `--validate-only` is set)

Each bundle runs in parallel, with prefixed output and a final success/failure summary.

## Script usage

```bash
# Deploy all bundles to the default target
./run-databricks-bundles.sh

# Deploy all bundles to a specific target
./run-databricks-bundles.sh --target prod

# Validate only (no deploy)
./run-databricks-bundles.sh --validate-only

# Show help
./run-databricks-bundles.sh --help
```

## Deploy a single bundle manually

```bash
# Validate and deploy bundle_a
cd bundle_a
databricks bundle validate
databricks bundle deploy
```

# Configuration Files

Shared bundle config examples live under `bundle/`:

- `bundle/targets.yml` defines `dev` (default) and `prod` targets.
- `bundle/variables.yml` defines `root_catalog` and `root_schema` defaults.

These files document target/variable conventions used in this repository.

# Artifact Pattern

Every bundle defines two artifacts in its `databricks.yml`:

- `platform`: the bundle-local wheel from `path: .`
- `utils`: the shared wheel from `path: ..` (the root `polly-pony-utils` package)

Both are configured as `type: whl` and built with:

```bash
uv lock && uv build # ensure dependencies are aligned with the pyproject.toml
```

This keeps shared code reusable while preserving independent bundle deployment units.

# Dependency Management

Each bundle depends on `polly-pony-utils` via local editable source mapping in the bundle's `pyproject.toml`:

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
