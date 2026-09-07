#!/usr/bin/env bash
# Installs nvm and the latest LTS Node.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/colors.sh
source "$DOTFILES/lib/colors.sh"

NVM_VERSION="v0.40.3"
export NVM_DIR="$HOME/.nvm"

if [ -s "$NVM_DIR/nvm.sh" ]; then
    ok "nvm already installed."
else
    info "Installing nvm $NVM_VERSION..."
    curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash
fi

# shellcheck disable=SC1091
. "$NVM_DIR/nvm.sh"

if nvm ls --no-colors lts/* >/dev/null 2>&1; then
    ok "Node LTS already installed ($(node --version))."
else
    info "Installing Node LTS..."
    nvm install --lts
    nvm alias default 'lts/*'
fi
