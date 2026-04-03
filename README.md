# killian31 dot files

Personal setup focused on:

- Bash aliases/functions
- Neovim config

This guide is a repeatable playbook to reinstall everything on a fresh machine.

## Scope

- Target OS: Ubuntu 24.04+
- Main entrypoint: `./install.sh`
- Default installed modules: `bash` and `nvim`
- Repository: `https://github.com/killian31/my-dot-files.git`

## One-command bootstrap (after clone)

From the repository root:

```sh
./bootstrap-ubuntu.sh
```

Optional flags:

```sh
./bootstrap-ubuntu.sh --minimal
./bootstrap-ubuntu.sh --help
```

`--minimal` skips extra formatter/linter packages.

## Fast Reinstall (copy/paste)

Run these commands on a fresh machine:

```sh
# 1) Base tools
sudo apt update
sudo apt install -y software-properties-common curl git

# 2) Node 22+ (Copilot + markdownlint)
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# 3) Neovim 0.11+ (Ubuntu default is too old)
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

# 4) Other required tools
sudo apt install -y \
	ripgrep fd-find npm \
	build-essential cmake unzip wget jq \
	python3 python3-pip python3-venv pipx \
	shellcheck luarocks

# 5) fd alias binary name fix on Ubuntu (fdfind -> fd)
mkdir -p ~/.local/bin
ln -sf "$(command -v fdfind)" ~/.local/bin/fd

# 6) Clone and install dotfiles
git clone https://github.com/killian31/my-dot-files.git ~/github/my-dot-files
cd ~/github/my-dot-files
./install.sh

# 7) Reload shell and verify alias
source ~/.bashrc
alias vim

# 8) First Neovim start (installs plugins)
nvim
```

## Recommended Optional Tools

These remove healthcheck warnings and enable formatter/linter integrations:

```sh
pipx ensurepath
pipx install black isort ruff yamllint
pipx install codespell proselint rstcheck beautysh

npm install -g markdownlint-cli
```

Optional Lua formatter:

```sh
curl https://sh.rustup.rs -sSf | sh
. "$HOME/.cargo/env"
cargo install stylua
```

## Install Script Usage

From repo root:

```sh
./install.sh
```

Install only one module:

```sh
./install.sh bash
./install.sh nvim
```

Help:

```sh
./install.sh --help
```

## What The Installer Changes

- Bash installer links `bash/.bashrc.d` to `~/.bashrc.d`
- Bash installer appends a loader block in `~/.bashrc` (once)
- Neovim installer links:
	- `nvim/init.lua` -> `~/.config/nvim/init.lua`
	- `nvim/lua` -> `~/.config/nvim/lua`
	- `nvim/ftplugin` -> `~/.config/nvim/ftplugin`
- Existing targets are backed up with timestamp suffixes like `.bak.YYYYMMDD-HHMMSS`

## Post-Install Verification

Shell:

```sh
command -v nvim
nvim --version | head -n 3
node --version
alias vim
```

Neovim:

```vim
:checkhealth
:Lazy
```

Copilot auth (one-time per machine):

```vim
:Copilot auth
```

## Updating Later

When this repo changes:

```sh
cd ~/github/my-dot-files
git pull
./install.sh
source ~/.bashrc
```

## Troubleshooting

### `vim` does not open Neovim

```sh
source ~/.bashrc
alias vim
```

Expected: `alias vim='nvim'`

### `fd` not found but `fdfind` exists

```sh
mkdir -p ~/.local/bin
ln -sf "$(command -v fdfind)" ~/.local/bin/fd
source ~/.bashrc
```

### Copilot says Node is too old

```sh
node --version
```

Must be 22+.

### Copilot auth file missing

Run inside Neovim:

```vim
:Copilot auth
```

### Plugin/bootstrap issues

Inside Neovim:

```vim
:Lazy sync
:checkhealth
```

## Notes For Non-Ubuntu Systems

- Keep the same install order: Node 22+, Neovim 0.11+, then tools.
- Adapt package names (`fd-find`/`fdfind`, etc.) to your distro.
