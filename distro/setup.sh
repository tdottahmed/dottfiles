#!/usr/bin/env bash
# Distro-specific setup hook.
#
# Runs BEFORE packages from distro/packages.list are installed, so this is the
# place to enable extra repositories (RPM Fusion, PPAs, backports) or install
# anything the package manager cannot handle on its own.
#
# On `main` this is intentionally a no-op. Each distro branch overrides it.

info "No distro-specific setup on this branch (generic baseline)."
