# polly-pony

## Why split a bundle?

Databricks Asset Bundles use Terraform under the hood. By default, all resources live in a single state file — one `databricks.yml`, one deployment, one lock. This works fine for small projects, but as the number of pipelines, jobs, and artifacts grows, a single bundle becomes a bottleneck:

- **Slow deployments** — Terraform must plan and apply every resource, even if you only changed one pipeline. The more resources in the state, the longer each deploy takes.
- **Merge conflicts on the lock** — only one `databricks bundle deploy` can run at a time per bundle, if you dont use a technique to separate the work. When multiple team members deploy concurrently, one blocks the other.
- **Blast radius** — a bad change to one pipeline can stall the deployment of everything else in the same bundle.

This repository demonstrates how to split a single Databricks Asset Bundle into multiple independent bundles (`bundle_a`, `bundle_b`, `bundle_c`), each with its own `databricks.yml`, its own Terraform state, and its own wheel. Because each bundle is a standalone deployment unit:

- **Deployments are faster** — each bundle only plans and applies its own resources.
- **Teams don't block each other** — two people can deploy different bundles at the same time, since each bundle holds its own state lock.
- **Failures are isolated** — a broken deploy in `bundle_a` has no effect on `bundle_b` or `bundle_c`.

Shared Python code lives in `polly-pony-utils` at the repository root. Each bundle declares it as a dependency and ships it as a second wheel artifact, so common logic is reused without coupling the deployments together.

## Deployment

All bundles are deployed in parallel using `deploy.sh`. The script auto-discovers every directory containing a `databricks.yml` and runs `databricks bundle validate` + `databricks bundle deploy` in each.

```bash
# Deploy all bundles to the default target
./deploy.sh

# Deploy all bundles to a specific target
./deploy.sh --target prod

# Validate only (no deploy)
./deploy.sh --validate-only

# Show help
./deploy.sh --help
```

Each bundle produces two wheel artifacts during deployment:

- Its own wheel (e.g. `bundle_a-0.1.0-py3-none-any.whl`)
- The shared `polly_pony_utils-0.1.0-py3-none-any.whl`

Both wheels are built and uploaded automatically by `databricks bundle deploy`.

To deploy a single bundle manually:

```bash
cd bundle_a
databricks bundle deploy            # default target
databricks bundle deploy -t prod    # specific target
```

## Dependency Management

Each bundle (`bundle_a`, `bundle_b`, `bundle_c`) is deployed with two wheels: its own wheel and the shared `polly-pony-utils` wheel. Both are installed in the same Python environment on the cluster, so dependency versions must be compatible.

### Decision Tree: Where to Declare a Dependency

```text
Do I need a new Python package?
│
├─ YES: Is it used by polly-pony-utils?
│       │
│       ├─ YES: Declare it in polly-pony-utils/pyproject.toml
│       │       └─ Does a bundle also use it directly?
│       │               │
│       │               ├─ YES: Do NOT add it to the bundle.
│       │               │       It comes in transitively via polly-pony-utils.
│       │               │
│       │               └─ NO:  Nothing to do.
│       │
│       └─ NO:  Is it used by only one bundle?
│               │
│               ├─ YES: Declare it in that bundle's pyproject.toml only.
│               │
│               └─ NO:  Used by multiple bundles?
│                       │
│                       └─ YES: Consider moving it to polly-pony-utils.
│                               If that doesn't make sense, declare the
│                               same version range in each bundle.
│
└─ NO:  Nothing to do.
```

### Rules

1. **Shared deps live in `polly-pony-utils`** — if `polly-pony-utils` needs a package, that's the single source of truth for the version range. Bundles get it transitively.
2. **Never duplicate a dependency** — if a package is already declared in `polly-pony-utils`, do not also declare it in a bundle. Conflicting version pins will cause pip to fail at cluster startup.
3. **Bundle-only deps stay in the bundle** — packages that only one bundle needs belong in that bundle's `pyproject.toml`.
4. **Multi-bundle deps without utils usage** — if multiple bundles need the same package but `polly-pony-utils` doesn't, prefer adding it to `polly-pony-utils` anyway to centralize the version pin. If that's not appropriate, use identical version ranges across bundles.
