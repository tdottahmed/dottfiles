#!/usr/bin/env bash
# Distro / package-manager detection.

# Prints the distro id from /etc/os-release (fedora, ubuntu, debian, ...).
detect_distro() {
    if [ -r /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        echo "${ID:-unknown}"
    else
        echo "unknown"
    fi
}

# Prints the package manager available on this system.
detect_package_manager() {
    if command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v apt-get &>/dev/null; then
        echo "apt"
    else
        echo "unknown"
    fi
}

# Installs the packages given as arguments using the detected package manager.
install_packages() {
    [ "$#" -eq 0 ] && return 0
    local pm
    pm="$(detect_package_manager)"
    case "$pm" in
        dnf) sudo dnf install -y "$@" ;;
        apt) sudo apt-get update -qq && sudo apt-get install -y "$@" ;;
        *)   die "No supported package manager found (need dnf or apt)." ;;
    esac
}
