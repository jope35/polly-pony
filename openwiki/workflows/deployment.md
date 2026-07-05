# Deployment workflows

This page describes how agents and operators validate, deploy, and destroy Polly-Pony bundles. All commands assume you are authenticated with the Databricks CLI against the workspace configured in [`bundle/targets.yml`](../../bundle/targets.yml).

## Bundle discovery

[`run-databricks-bundles.sh`](../../run-databricks-bundles.sh) discovers bundles by running:

```bash
find "$REPO_ROOT" -maxdepth 2 -name "databricks.yml" -type f
```

**Implications for agents:**

- Valid layout: `./bundle_a/databricks.yml`, `./bundle_b/databricks.yml`
- Invalid layout: `./packages/my_bundle/databricks.yml` (too deep — will not be discovered)
- To support deeper layouts, the script itself must be modified

## Root orchestration script

### Validate only (safe first step)

```bash
./run-databricks-bundles.sh --validate-only
```

Runs `databricks bundle validate` in each bundle directory. Does not deploy. Artifact build steps may run as part of validation depending on CLI behavior.

### Validate and deploy (default)

```bash
./run-databricks-bundles.sh
```

For each bundle, in parallel:

1. `databricks bundle validate`
2. `databricks bundle deploy` (if validation succeeds)

### Deploy to a named target

```bash
./run-databricks-bundles.sh --target dev
./run-databricks-bundles.sh --target prod
```

The `-t` / `--target` flag is forwarded to every `databricks bundle` invocation.

### Destroy all bundles (destructive)

```bash
./run-databricks-bundles.sh --destroy-only --target dev
```

Runs `databricks bundle destroy --auto-approve` per bundle. **Permanently removes deployed resources** for all discovered bundles on the given target.

### Help

```bash
./run-databricks-bundles.sh --help
```

## Single-bundle workflow

When working on one bundle, `cd` into its directory:

```bash
cd bundle_a
databricks bundle validate
databricks bundle deploy

# With explicit target
databricks bundle validate -t dev
databricks bundle deploy -t dev
```

Same pattern applies to `bundle_b`.

## Parallel execution behavior

The root script:

- Spawns a **background subshell per bundle**
- Prefixes log lines with a color-coded bundle name (e.g. `[bundle_a]`)
- Traps `SIGINT`/`SIGTERM` to forward shutdown to child processes
- Exits **non-zero** if any bundle fails, listing failed bundle names in a summary

Agents modifying the script should preserve this error-aggregation behavior.

## Artifact build lifecycle

During validate/deploy, Databricks bundles build artifacts defined in each `databricks.yml`:

```yaml
artifacts:
  platform:
    type: whl
    path: .
    build: uv lock && uv build
  utils:
    type: whl
    path: ..
    build: uv lock && uv build
```

**Prerequisites on the machine running the CLI:**

- `uv` must be on `PATH`
- Network access for `uv lock` if dependencies need resolution

Wheels land in `dist/` under the respective build context (bundle dir for `platform`, repo root for `utils`). Resource YAML globs (`../dist/*.whl`, `../../dist/*.whl`) must stay consistent with these paths.

## Pre-deployment checklist for agents

Before running deploy commands:

1. **Update `bundle/targets.yml`** — replace `<<FILL IN YOUR HOST>>` with a real workspace URL.
2. **Confirm Databricks auth** — `databricks auth login` or your org's SSO/profile setup.
3. **Run validate first** — `./run-databricks-bundles.sh --validate-only` catches config and build issues early.
4. **Check UC variables** — `root_catalog` and `root_schema` in `bundle/variables.yml` must exist in the target workspace (especially for `bundle_b`).

## Troubleshooting

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| "No databricks.yml files found" | Bundle nested deeper than depth 2 | Move bundle or update discovery in script |
| Authentication / permission errors | CLI not authenticated or insufficient workspace permissions | Re-authenticate; verify deploy rights |
| Missing wheels in job/pipeline | Artifact build failed or paths wrong | Run validate; check `dist/` output and resource YAML globs |
| Wrong workspace | Placeholder host still in `targets.yml` | Update `bundle/targets.yml` for your environment |
| `--validate-only` and `--destroy-only` together | Mutually exclusive flags | Use one mode at a time |

## Agent workflow recommendations

### Making code changes

1. Read [architecture overview](../architecture/overview.md) to understand which bundle owns the change.
2. Edit source files in the appropriate bundle or `src/polly_pony_utils/`.
3. If dependencies changed, run `uv lock` in the affected `pyproject.toml` directory.
4. Run pre-commit: `uv run --group dev pre-commit run --all-files`
5. Validate: `./run-databricks-bundles.sh --validate-only`

### Adding a new bundle

1. Create directory at repo root (e.g. `bundle_c/`) with `databricks.yml` at that level.
2. Copy artifact pattern from `bundle_a/databricks.yml`.
3. Add `pyproject.toml`, `resources/`, and `src/` as needed.
4. Confirm discovery: `./run-databricks-bundles.sh --validate-only` should list the new bundle.

### Changing shared config

Edits to `bundle/targets.yml` or `bundle/variables.yml` affect **all bundles**. Validate every bundle after shared config changes.

## Related pages

- [Quickstart](../quickstart.md)
- [Architecture overview](../architecture/overview.md)
- [Human README — Troubleshooting](../../README.md#troubleshooting)
