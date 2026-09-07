#!/usr/bin/env bash
# Downloads the Nerd Fonts used by kitty and tmux into ~/.local/share/fonts.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/colors.sh
source "$DOTFILES/lib/colors.sh"

NERD_FONTS_VERSION="v3.2.1"
FONT_DIR="$HOME/.local/share/fonts"

# Nerd Fonts release archive names (without the .zip).
FONTS=(
    CascadiaCode
    JetBrainsMono
)

mkdir -p "$FONT_DIR"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

for font in "${FONTS[@]}"; do
    if [ -d "$FONT_DIR/$font" ]; then
        ok "$font already installed."
        continue
    fi
    info "Downloading $font..."
    url="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION/$font.zip"
    if ! curl -fsSL -o "$tmp/$font.zip" "$url"; then
        warn "Could not download $font, skipping."
        continue
    fi
    unzip -q -o "$tmp/$font.zip" -d "$FONT_DIR/$font" -x '*.md' '*.txt'
    ok "$font installed."
done

info "Rebuilding font cache..."
fc-cache -f >/dev/null
ok "Fonts ready."
