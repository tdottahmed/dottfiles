#!/usr/bin/env bash
# Ubuntu-specific setup. Sourced by scripts/install-packages.sh before the
# packages in distro/packages.list are installed.

info "Refreshing apt package lists..."
sudo apt-get update -qq

if ! command -v add-apt-repository &>/dev/null; then
    info "Installing software-properties-common (for add-apt-repository)..."
    sudo apt-get install -y software-properties-common
fi

# Ubuntu's neovim is usually a release or two behind. The unstable PPA tracks
# upstream, which matters because the nvim config here uses recent APIs.
if ! grep -rq 'neovim-ppa/unstable' /etc/apt/sources.list.d/ 2>/dev/null; then
    info "Adding the neovim unstable PPA..."
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get update -qq
else
    ok "neovim PPA already added."
fi

# ondrej/php gives you every PHP version side by side plus `switchphp` support.
if ! grep -rq 'ondrej/php' /etc/apt/sources.list.d/ 2>/dev/null; then
    info "Adding the ondrej/php PPA..."
    sudo add-apt-repository -y ppa:ondrej/php
    sudo apt-get update -qq
else
    ok "PHP PPA already added."
fi

# Ubuntu ships fd as fdfind and rg's binary is fine; link fd to the usual name.
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    ok "Linked fdfind -> ~/.local/bin/fd"
fi
