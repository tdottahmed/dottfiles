#!/usr/bin/env bash
# Symlinks every config package in this repo into $HOME using GNU stow.
set -uo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." && pwd)"
# shellcheck source=../lib/colors.sh
source "$DOTFILES/lib/colors.sh"

cd "$DOTFILES"

command -v stow >/dev/null 2>&1 || die "stow is not installed. Run scripts/install-packages.sh first."

# Every top-level directory is a stow package, except those in .installignore.
list_packages() {
    find . -maxdepth 1 -mindepth 1 -type d \
        | sed 's|^\./||' \
        | sort \
        | grep -v -x -f ./.installignore
}

# stow "folds" a package directory into a single symlink when the target does
# not exist yet. For ~/.ssh that would point the whole directory at this repo,
# and the next ssh-keygen would write a private key straight into git. Creating
# the directory first forces stow to link the individual config file instead.
mkdir -p "$HOME/.ssh/config.d"
chmod 700 "$HOME/.ssh" "$HOME/.ssh/config.d"

info "Stowing config packages into $HOME ..."
failed=()
while read -r pkg; do
    [ -z "$pkg" ] && continue
    if output="$(stow --restow --target="$HOME" "$pkg" 2>&1)"; then
        ok "$pkg"
    else
        failed+=("$pkg")
        error "$pkg"
        echo "$output" | sed 's/^/      /'
    fi
done < <(list_packages)

if [ "${#failed[@]}" -gt 0 ]; then
    echo
    warn "These packages were skipped because $HOME already has real files there:"
    warn "  ${failed[*]}"
    warn "Back up the conflicting paths and delete them, then re-run this script."
    warn "To let stow take over the existing files instead (it moves them into the"
    warn "repo, so check 'git diff' afterwards):  stow --adopt --restow -t \"\$HOME\" <pkg>"
    exit 1
fi

ok "All packages stowed."
