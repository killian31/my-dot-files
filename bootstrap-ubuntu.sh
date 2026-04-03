#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
MINIMAL=0

print_help() {
    cat <<'EOF'
Usage: ./bootstrap-ubuntu.sh [--minimal] [--help]

Bootstraps Ubuntu with dependencies for this dotfiles repo,
then runs ./install.sh.

Options:
  --minimal   Skip optional formatter/linter installs
  --help      Show this help
EOF
}

for arg in "$@"; do
    case "$arg" in
        --minimal)
            MINIMAL=1
            ;;
        --help)
            print_help
            exit 0
            ;;
        *)
            echo "Unknown option: $arg" >&2
            print_help >&2
            exit 1
            ;;
    esac
done

if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    if [ "${ID:-}" != "ubuntu" ]; then
        echo "Warning: this script is tailored for Ubuntu, detected ID=${ID:-unknown}." >&2
    fi
fi

echo "[1/7] Installing base tools..."
sudo apt update
sudo apt install -y software-properties-common curl git

echo "[2/7] Installing Node.js 22..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

echo "[3/7] Installing Neovim from PPA..."
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

echo "[4/7] Installing core dependencies..."
sudo apt install -y \
    ripgrep fd-find npm \
    build-essential cmake unzip wget jq \
    python3 python3-pip python3-venv pipx \
    shellcheck luarocks

echo "[5/7] Creating fd symlink (fdfind -> fd)..."
mkdir -p "$HOME/.local/bin"
ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"

if [ "$MINIMAL" -eq 0 ]; then
    echo "[6/7] Installing optional formatter/linter tools..."
    pipx ensurepath
    pipx install black || true
    pipx install isort || true
    pipx install ruff || true
    pipx install yamllint || true
    pipx install codespell || true
    pipx install proselint || true
    pipx install rstcheck || true
    pipx install beautysh || true
    sudo npm install -g markdownlint-cli
else
    echo "[6/7] Skipping optional tools (--minimal)."
fi

echo "[7/7] Installing dotfiles modules..."
cd "$SCRIPT_DIR"
./install.sh

echo "Done."
echo "Next steps:"
echo "  1) source ~/.bashrc"
echo "  2) nvim"
echo "  3) :checkhealth"
echo "  4) :Copilot auth"
