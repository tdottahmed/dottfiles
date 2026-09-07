#!/usr/bin/env bash
# Debian-specific setup. Sourced by scripts/install-packages.sh before the
# packages in distro/packages.list are installed.

CODENAME="$(. /etc/os-release && echo "${VERSION_CODENAME:-}")"

info "Refreshing apt package lists..."
sudo apt-get update -qq

# Debian stable ships old versions of neovim and friends. Backports carries
# newer ones without pulling in testing.
if [ -n "$CODENAME" ] && ! grep -rq "${CODENAME}-backports" /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null; then
    info "Enabling ${CODENAME}-backports..."
    echo "deb http://deb.debian.org/debian ${CODENAME}-backports main contrib non-free non-free-firmware" \
        | sudo tee "/etc/apt/sources.list.d/${CODENAME}-backports.list" >/dev/null
    sudo apt-get update -qq
else
    ok "Backports already enabled (or codename unknown)."
fi

# Pull neovim from backports specifically; the rest can come from stable.
if [ -n "$CODENAME" ]; then
    info "Installing neovim from ${CODENAME}-backports..."
    sudo apt-get install -y -t "${CODENAME}-backports" neovim || \
        warn "neovim not in backports, falling back to the stable version."
fi

# Debian ships fd as fdfind; link it to the name everything expects.
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    ok "Linked fdfind -> ~/.local/bin/fd"
fi
