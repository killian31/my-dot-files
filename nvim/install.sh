#!/usr/bin/env sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TARGET_DIR="$HOME/.config/nvim"

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

echo "Installing Neovim config files..."
link_path "$SCRIPT_DIR/init.lua" "$TARGET_DIR/init.lua"
link_path "$SCRIPT_DIR/lua" "$TARGET_DIR/lua"
link_path "$SCRIPT_DIR/ftplugin" "$TARGET_DIR/ftplugin"

echo "Done"
