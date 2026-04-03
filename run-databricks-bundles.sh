#!/usr/bin/env bash
set -uo pipefail

# Resolve script location so it works regardless of where it's called from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATE_ONLY=false
DESTROY_ONLY=false
TARGET=""

# Distinct colors so parallel output from different bundles is easy to tell apart
COLORS=("\033[36m" "\033[33m" "\033[35m" "\033[32m" "\033[34m" "\033[91m")
RESET="\033[0m"

usage() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Discover all Databricks bundles (directories with databricks.yml)"
    echo "and run validate+deploy (or destroy) in each, in parallel."
    echo ""
    echo "Options:"
    echo "  -t, --target TARGET   Deploy to a specific target (e.g. dev, prod)"
    echo "  -v, --validate-only   Only run 'databricks bundle validate', skip deploy"
    echo "  -d, --destroy-only    Only run 'databricks bundle destroy --auto-approve' (permanent delete), skip validate/deploy"
    echo "  -h, --help            Show this help message"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--target)
            if [[ $# -lt 2 ]]; then
                echo "Error: $1 requires a target name (e.g. dev, prod)."
                usage
                exit 1
            fi
            TARGET="$2"
            shift 2
            ;;
        -v|--validate-only)
            VALIDATE_ONLY=true
            shift
            ;;
        -d|--destroy-only)
            DESTROY_ONLY=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

if [[ "$VALIDATE_ONLY" == true && "$DESTROY_ONLY" == true ]]; then
    echo "Error: --validate-only and --destroy-only are mutually exclusive."
    usage
    exit 1
fi

# Find all bundle directories so we know what to validate/deploy
bundle_dirs=()
while IFS= read -r yml; do
    bundle_dirs+=("$(dirname "$yml")")
done < <(find "$SCRIPT_DIR" -maxdepth 2 -name "databricks.yml" -type f | sort)

if [[ ${#bundle_dirs[@]} -eq 0 ]]; then
    echo "No databricks.yml files found. Nothing to do."
    exit 0
fi

# Show the user which bundles will be processed and in what mode
echo "========================================"
echo "Found ${#bundle_dirs[@]} bundle(s):"
for dir in "${bundle_dirs[@]}"; do
    echo "  - $(basename "$dir") (${dir})"
done
echo "========================================"

echo "Target: ${TARGET:-(default)}"

if $DESTROY_ONLY; then
    echo "Mode: destroy only"
elif $VALIDATE_ONLY; then
    echo "Mode: validate only"
else
    echo "Mode: validate + deploy"
fi
echo ""

# Each bundle is independent, so process them in parallel to save time.
# We spawn a subshell per bundle (...) & and record its PID: the parent must
# wait on those PIDs later so we know pass/fail per bundle and the shell does
# not exit while children are still running.
pids=()
names=()
color_idx=0

# Without this, Ctrl+C (SIGINT) or SIGTERM only hits the parent shell; databricks
# child processes keep running as orphans. The trap forwards shutdown to every
# job still listed by jobs -p, then wait drains them.
cleanup_background() {
    local j
    for j in $(jobs -p); do
        kill -TERM "$j" 2>/dev/null || true
    done
    wait 2>/dev/null || true
}
trap cleanup_background INT TERM

for dir in "${bundle_dirs[@]}"; do
    name="$(basename "$dir")"
    color="${COLORS[$((color_idx % ${#COLORS[@]}))]}"
    color_idx=$((color_idx + 1))
    (
        cd "$dir"
        prefix="${color}[$name]${RESET}"
        target_args=()
        if [[ -n "$TARGET" ]]; then
            target_args=(-t "$TARGET")
        fi
        if $DESTROY_ONLY; then
            echo -e "$prefix Starting destroy..."
            if ! databricks bundle destroy --auto-approve "${target_args[@]}" 2>&1 | while IFS= read -r line; do echo -e "$prefix $line"; done; then
                echo -e "$prefix Destroy FAILED"
                exit 1
            fi
            echo -e "$prefix Destroy succeeded"
        else
            echo -e "$prefix Starting validation..."
            if ! databricks bundle validate "${target_args[@]}" 2>&1 | while IFS= read -r line; do echo -e "$prefix $line"; done; then
                echo -e "$prefix Validation FAILED"
                exit 1
            fi
            echo -e "$prefix Validation succeeded"

            if ! $VALIDATE_ONLY; then
                echo -e "$prefix Starting deployment..."
                if ! databricks bundle deploy "${target_args[@]}" 2>&1 | while IFS= read -r line; do echo -e "$prefix $line"; done; then
                    echo -e "$prefix Deployment FAILED"
                    exit 1
                fi
                echo -e "$prefix Deployment succeeded"
            fi
        fi
    ) &
    pids+=($!)
    names+=("$name")
done

# Reap each background subshell in order; wait returns the child's exit status
# so we can list which bundle names failed without using set -m or job control.
failed=()
for i in "${!pids[@]}"; do
    if ! wait "${pids[$i]}"; then
        failed+=("${names[$i]}")
    fi
done

# All bundle subshells have finished; nothing left for cleanup_background to kill.
# Reset INT/TERM to default so a signal during the summary does not run that handler
# (which would be pointless and could confuse exit behavior).
trap - INT TERM

# Give the user a clear summary of what succeeded and what didn't
echo ""
echo "========================================"
if [[ ${#failed[@]} -eq 0 ]]; then
    echo "All ${#bundle_dirs[@]} bundle(s) completed successfully."
    exit 0
else
    echo "FAILED bundles (${#failed[@]}/${#bundle_dirs[@]}):"
    for name in "${failed[@]}"; do
        echo "  - $name"
    done
    exit 1
fi
