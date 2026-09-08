#!/usr/bin/env bash
# Debian-specific setup. Sourced by scripts/install-packages.sh before the
# packages in distro/packages.list are installed.

CODENAME="$(. /etc/os-release && echo "${VERSION_CODENAME:-}")"
DEBIAN_MAJOR="$(. /etc/os-release && echo "${VERSION_ID:-}")"
DEBIAN_MAJOR="${DEBIAN_MAJOR%%.*}"

info "Refreshing apt package lists..."
sudo apt-get update -qq

# Set to the suite name once backports is known to work, so the neovim install
# below knows whether there is anything to install from.
BACKPORTS_SUITE=""

# Enables <codename>-backports, but never aborts the install if it does not
# take. The suite can be missing entirely -- testing and sid have none, and a
# fresh stable release has none for its first months -- a Debian derivative can
# report a codename deb.debian.org has never heard of, and the mirror is not
# always reachable. In each of those apt cannot read the new source, and
# leaving it behind would fail every later apt-get update, so take it back out
# and carry on with the packages in stable.
enable_backports() {
    local suite="${CODENAME}-backports"
    local list="/etc/apt/sources.list.d/${suite}.list"

    if grep -rq "$suite" /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null; then
        ok "$suite already enabled."
        BACKPORTS_SUITE="$suite"
        return 0
    fi

    # non-free-firmware is only a component from Debian 12 (bookworm) on;
    # asking for it on bullseye 404s the whole suite.
    local components="main contrib non-free non-free-firmware"
    if [ -n "$DEBIAN_MAJOR" ] && [ "$DEBIAN_MAJOR" -lt 12 ] 2>/dev/null; then
        components="main contrib non-free"
    fi

    info "Enabling $suite..."
    echo "deb http://deb.debian.org/debian $suite $components" \
        | sudo tee "$list" >/dev/null

    if ! sudo apt-get update -qq; then
        warn "apt could not read $suite. Does it exist for this release?"
        warn "Removing $list so it does not break the package install."
        sudo rm -f "$list"
        sudo apt-get update -qq || true
        return 0
    fi

    ok "$suite enabled."
    BACKPORTS_SUITE="$suite"
}

if [ -n "$CODENAME" ]; then
    enable_backports
else
    warn "No VERSION_CODENAME in /etc/os-release; skipping backports."
    warn "Continuing with the packages from the distro repos."
fi

# Debian stable ships old versions of neovim and friends, so pull that one from
# backports specifically; the rest can come from stable.
if [ -n "$BACKPORTS_SUITE" ]; then
    info "Installing neovim from $BACKPORTS_SUITE..."
    sudo apt-get install -y -t "$BACKPORTS_SUITE" neovim || \
        warn "neovim not in $BACKPORTS_SUITE, falling back to the stable version."
fi

# Debian ships fd as fdfind; link it to the name everything expects.
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    ok "Linked fdfind -> ~/.local/bin/fd"
fi
