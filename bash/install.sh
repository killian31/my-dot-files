#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SOURCE_DIR="$SCRIPT_DIR/.bashrc.d"
TARGET_DIR="$HOME/.bashrc.d"
TARGET_RC="$HOME/.bashrc"

backup_path() {
    path="$1"
    if [ -e "$path" ] || [ -L "$path" ]; then
        stamp=$(date +%Y%m%d-%H%M%S)
        mv "$path" "$path.bak.$stamp"
        echo "Backed up $path to $path.bak.$stamp"
    fi
}

link_path() {
    src="$1"
    dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        return
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        backup_path "$dst"
    fi

    ln -s "$src" "$dst"
}

if [ ! -f "$TARGET_RC" ]; then
    touch "$TARGET_RC"
fi

echo "Installing bash config files..."
link_path "$SOURCE_DIR" "$TARGET_DIR"

if ! grep -q "my-dot-files bash" "$TARGET_RC"; then
    cat >> "$TARGET_RC" <<'EOF'

# >>> my-dot-files bash >>>
if [ -f "$HOME/.bashrc.d/main.sh" ]; then
    . "$HOME/.bashrc.d/main.sh"
fi
# <<< my-dot-files bash <<<
EOF
    echo "Added dotfiles loader to $TARGET_RC"
fi

echo "Done"
