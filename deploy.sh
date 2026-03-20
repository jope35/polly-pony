#!/usr/bin/env bash
set -uo pipefail

# Resolve script location so it works regardless of where it's called from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATE_ONLY=false
TARGET=""

# Distinct colors so parallel output from different bundles is easy to tell apart
COLORS=("\033[36m" "\033[33m" "\033[35m" "\033[32m" "\033[34m" "\033[91m")
RESET="\033[0m"

usage() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Discover all Databricks bundles (directories with databricks.yml)"
    echo "and run validate + deploy in each, in parallel."
    echo ""
    echo "Options:"
    echo "  -t, --target TARGET   Deploy to a specific target (e.g. dev, prod)"
    echo "  -v, --validate-only   Only run 'databricks bundle validate', skip deploy"
    echo "  -h, --help            Show this help message"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--target)
            TARGET="$2"
            shift 2
            ;;
        -v|--validate-only)
            VALIDATE_ONLY=true
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

if $VALIDATE_ONLY; then
    echo "Mode: validate only"
else
    echo "Mode: validate + deploy"
fi
echo ""

# Each bundle is independent, so process them in parallel to save time
pids=()
names=()
color_idx=0

for dir in "${bundle_dirs[@]}"; do
    name="$(basename "$dir")"
    color="${COLORS[$((color_idx % ${#COLORS[@]}))]}"
    color_idx=$((color_idx + 1))
    (
        cd "$dir"
        prefix="${color}[$name]${RESET}"
        echo -e "$prefix Starting validation..."
        if ! databricks bundle validate ${TARGET:+-t "$TARGET"} 2>&1 | while IFS= read -r line; do echo -e "$prefix $line"; done; then
            echo -e "$prefix Validation FAILED"
            exit 1
        fi
        echo -e "$prefix Validation succeeded"

        if ! $VALIDATE_ONLY; then
            echo -e "$prefix Starting deployment..."
            if ! databricks bundle deploy ${TARGET:+-t "$TARGET"} 2>&1 | while IFS= read -r line; do echo -e "$prefix $line"; done; then
                echo -e "$prefix Deployment FAILED"
                exit 1
            fi
            echo -e "$prefix Deployment succeeded"
        fi
    ) &
    pids+=($!)
    names+=("$name")
done

# Collect results from all parallel jobs so we can report which bundles failed
failed=()
for i in "${!pids[@]}"; do
    if ! wait "${pids[$i]}"; then
        failed+=("${names[$i]}")
    fi
done

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
