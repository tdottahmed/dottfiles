#!/usr/bin/env bash
# Ubuntu-specific setup. Sourced by scripts/install-packages.sh before the
# packages in distro/packages.list are installed.

info "Refreshing apt package lists..."
sudo apt-get update -qq

if ! command -v add-apt-repository &>/dev/null; then
    info "Installing software-properties-common (for add-apt-repository)..."
    sudo apt-get install -y software-properties-common
fi

# Adds a PPA, but never aborts the install if it cannot be added. Launchpad is
# not always reachable (broken IPv6 routes, ISP blocks), and Ubuntu derivatives
# such as Linux Mint sometimes add the PPA under their own release codename,
# which Launchpad has no series for. Either way, falling back to the packages
# in the distro repos beats failing the whole run.
#
# Usage: add_ppa ppa:neovim-ppa/unstable neovim
add_ppa() {
    local ppa="$1" what="$2"

    if grep -rq "${ppa#ppa:}" /etc/apt/sources.list.d/ 2>/dev/null; then
        ok "$what PPA already added."
        return 0
    fi

    info "Adding the $what PPA ($ppa)..."
    if ! sudo add-apt-repository -y "$ppa"; then
        warn "Could not add $ppa. Is launchpad.net reachable?"
        warn "Continuing with the $what packages from the distro repos."
        return 0
    fi

    # The PPA was written but apt cannot read it -- most likely the wrong
    # release codename. Take it back out, or every later apt-get update in
    # this run fails on it.
    if ! sudo apt-get update -qq; then
        warn "$ppa was added but apt could not read it (wrong release codename?)."
        warn "Removing it again so it does not break the package install."
        sudo add-apt-repository -r -y "$ppa" || true
        sudo apt-get update -qq || true
        return 0
    fi

    ok "$what PPA added."
}

# Ubuntu's neovim is usually a release or two behind. The unstable PPA tracks
# upstream, which matters because the nvim config here uses recent APIs.
add_ppa ppa:neovim-ppa/unstable neovim

# ondrej/php gives you every PHP version side by side plus `switchphp` support.
add_ppa ppa:ondrej/php PHP

# Ubuntu ships fd as fdfind and rg's binary is fine; link fd to the usual name.
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    ok "Linked fdfind -> ~/.local/bin/fd"
fi
