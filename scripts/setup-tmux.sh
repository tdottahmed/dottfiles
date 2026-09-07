#!/usr/bin/env bash
# Installs TPM (Tmux Plugin Manager).
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)"
# shellcheck source=../lib/colors.sh
source "$DOTFILES/lib/colors.sh"

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
    ok "TPM already installed."
else
    info "Cloning TPM into $TPM_DIR..."
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo
info "Start tmux and press 'prefix + I' to install the plugins."
