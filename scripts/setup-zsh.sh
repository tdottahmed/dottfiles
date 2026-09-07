#!/usr/bin/env bash
# Installs oh-my-zsh plus the plugins referenced by zsh/.zshrc.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)"
# shellcheck source=../lib/colors.sh
source "$DOTFILES/lib/colors.sh"

ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH_DIR/custom}"

if [ -d "$ZSH_DIR" ]; then
    ok "oh-my-zsh already installed."
else
    info "Installing oh-my-zsh..."
    # --keep-zshrc so our stowed .zshrc is not overwritten.
    RUNZSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended
fi

clone_plugin() {
    local name="$1" url="$2" dest="$ZSH_CUSTOM/plugins/$1"
    if [ -d "$dest" ]; then
        ok "plugin $name already present."
    else
        info "Cloning plugin $name..."
        git clone --depth=1 "$url" "$dest"
    fi
}

clone_plugin zsh-autosuggestions     https://github.com/zsh-users/zsh-autosuggestions
clone_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting

if [ "$SHELL" != "$(command -v zsh)" ]; then
    info "Setting zsh as the default shell (may ask for your password)..."
    chsh -s "$(command -v zsh)" || warn "chsh failed; run it manually."
else
    ok "zsh is already the default shell."
fi
