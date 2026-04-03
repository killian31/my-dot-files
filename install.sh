#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

print_help() {
    cat <<'EOF'
Usage: ./install.sh [module ...]

Modules:
  bash
  nvim

Options:
  --all     Install all modules
  --help    Show this help

Examples:
  ./install.sh
  ./install.sh bash nvim
  ./install.sh --all

Defaults:
  If no module is passed, installs: bash nvim
EOF
}

run_module() {
    module="$1"
    case "$module" in
        bash|nvim)
            echo "[install] $module"
            sh "$SCRIPT_DIR/$module/install.sh"
            ;;
        *)
            echo "Unknown module: $module" >&2
            echo "Use --help to list available modules." >&2
            exit 1
            ;;
    esac
}

if [ "${1:-}" = "--help" ]; then
    print_help
    exit 0
fi

if [ "${1:-}" = "--all" ]; then
    modules="bash nvim"
elif [ "$#" -gt 0 ]; then
    modules="$*"
else
    modules="bash nvim"
fi

for module in $modules; do
    run_module "$module"
done

echo "All selected modules installed."
