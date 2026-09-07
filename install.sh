#!/usr/bin/env bash
# Entry point. Run from a clone of this repo:
#
#   git clone https://github.com/tdottahmed/dottfiles.git ~/dotfiles
#   cd ~/dotfiles && ./install.sh
#
# Check out the branch matching your distro first (fedora, ubuntu, debian).
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/colors.sh
source "$DOTFILES/lib/colors.sh"
# shellcheck source=lib/distro.sh
source "$DOTFILES/lib/distro.sh"

DISTRO="$(detect_distro)"
BRANCH="$(git -C "$DOTFILES" rev-parse --abbrev-ref HEAD 2>/dev/null || echo unknown)"

echo -e "${BOLD}dotfiles${NC}  distro: ${CYAN}$DISTRO${NC}  branch: ${CYAN}$BRANCH${NC}"
echo

# Warn if a distro-specific branch exists but is not the one checked out.
if [ "$BRANCH" != "$DISTRO" ] && git -C "$DOTFILES" show-ref --verify --quiet "refs/heads/$DISTRO"; then
    warn "You are on '$BRANCH' but a '$DISTRO' branch exists. Consider: git switch $DISTRO"
    read -rp "Continue on '$BRANCH' anyway? [y/N] " reply
    [[ "$reply" =~ ^[Yy] ]] || exit 0
fi

"$DOTFILES/scripts/install-packages.sh"
"$DOTFILES/scripts/stow.sh"
"$DOTFILES/scripts/setup-fonts.sh"
"$DOTFILES/scripts/setup-node.sh"
"$DOTFILES/scripts/setup-tmux.sh"
"$DOTFILES/scripts/setup-zsh.sh"

echo
ok "Done. Open a new terminal to pick up the new shell config."
