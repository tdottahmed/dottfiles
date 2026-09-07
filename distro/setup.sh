#!/usr/bin/env bash
# Fedora-specific setup. Sourced by scripts/install-packages.sh before the
# packages in distro/packages.list are installed.

# RPM Fusion: needed for media codecs and a number of third-party packages.
if ! rpm -q rpmfusion-free-release &>/dev/null; then
    info "Enabling RPM Fusion (free + nonfree)..."
    release="$(rpm -E %fedora)"
    sudo dnf install -y \
        "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${release}.noarch.rpm" \
        "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${release}.noarch.rpm"
else
    ok "RPM Fusion already enabled."
fi

# dnf5 defaults are slow out of the box; these make it noticeably faster.
if ! grep -q '^max_parallel_downloads' /etc/dnf/dnf.conf 2>/dev/null; then
    info "Tuning /etc/dnf/dnf.conf (parallel downloads, fastest mirror)..."
    sudo tee -a /etc/dnf/dnf.conf >/dev/null <<'CONF'
max_parallel_downloads=10
fastestmirror=True
CONF
fi

# Docker CE is not in Fedora's repos. Uncomment if you want it alongside podman.
# if ! command -v docker &>/dev/null; then
#     info "Adding the Docker CE repository..."
#     sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
#     sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
#     sudo systemctl enable --now docker
#     sudo usermod -aG docker "$USER"
# fi
