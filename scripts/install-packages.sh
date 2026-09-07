#!/usr/bin/env bash
# Installs system packages listed in distro/packages.list.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)"
# shellcheck source=../lib/colors.sh
source "$DOTFILES/lib/colors.sh"
# shellcheck source=../lib/distro.sh
source "$DOTFILES/lib/distro.sh"

info "Detected distro: $(detect_distro) (package manager: $(detect_package_manager))"

# Ask for sudo up front so the rest runs unattended.
sudo -v

# Distro-specific setup (extra repos etc.) runs first.
if [ -f "$DOTFILES/distro/setup.sh" ]; then
    info "Running distro setup hook..."
    # shellcheck source=../distro/setup.sh
    source "$DOTFILES/distro/setup.sh"
fi

# Read the package list, stripping comments and blank lines.
mapfile -t packages < <(sed -e 's/#.*//' -e 's/[[:space:]]*$//' "$DOTFILES/distro/packages.list" | grep -v '^$')

if [ "${#packages[@]}" -eq 0 ]; then
    warn "distro/packages.list is empty, nothing to install."
    exit 0
fi

info "Installing: ${packages[*]}"
if install_packages "${packages[@]}"; then
    ok "All packages installed."
else
    die "Package installation failed."
fi
