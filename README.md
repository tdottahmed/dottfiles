# dotfiles

Terminal-focused dotfiles managed with [GNU stow](https://www.gnu.org/software/stow/).
Every top-level directory is a stow *package* whose contents mirror `$HOME`.

## Branches

`main` holds everything that is distro-agnostic. Distro branches sit on top of it
and change only two files — `distro/packages.list` and `distro/setup.sh`.

```
main                      shared config + install scripts
 ├── fedora               dnf package names + RPM Fusion setup
 ├── ubuntu               apt package names + PPA setup
 └── debian               apt package names + backports setup
```

Use the branch that matches your machine:

```sh
git clone https://github.com/tdottahmed/dottfiles.git ~/dotfiles
cd ~/dotfiles
git switch fedora     # or ubuntu / debian
./install.sh
```

When shared config changes on `main`, merge it down:

```sh
git switch fedora && git merge main
```

## What's in here

| Package     | Stows to                     | What it is                                  |
|-------------|------------------------------|---------------------------------------------|
| `zsh`       | `~/.zshrc`, `~/.config/zsh`  | oh-my-zsh setup, aliases, exports, helpers  |
| `nvim`      | `~/.config/nvim`             | Neovim (lazy.nvim, LSP, Blade/PHP support)  |
| `tmux`      | `~/.tmux.conf`, `~/.tmux-scripts` | tmux config + TPM plugins              |
| `kitty`     | `~/.config/kitty`            | kitty terminal, Catppuccin themes           |
| `vim`       | `~/.vimrc`                   | plain vim fallback                          |
| `composer`  | `~/.config/composer`         | global composer packages                    |
| `dev`       | `~/.config/git`, `~/env`     | git config, docker dev stack, podman policy |
| `bin`       | `~/.local/bin`               | personal scripts (`vhost`)                  |

Non-package directories, never symlinked (see `.installignore`):

| Directory  | What it is                                            |
|------------|-------------------------------------------------------|
| `lib`      | shared shell helpers (colors, distro detection)       |
| `scripts`  | the individual install steps                          |
| `distro`   | per-distro package list and setup hook                |

## Install

`./install.sh` runs each step in order. They are idempotent and can also be run
on their own:

```sh
scripts/install-packages.sh   # distro setup hook + distro/packages.list
scripts/stow.sh               # symlink every package into $HOME
scripts/setup-fonts.sh        # Nerd Fonts into ~/.local/share/fonts
scripts/setup-node.sh         # nvm + Node LTS
scripts/setup-tmux.sh         # TPM
scripts/setup-zsh.sh          # oh-my-zsh, plugins, default shell
```

## Adding a package

Create a directory whose layout mirrors `$HOME`, then re-run `scripts/stow.sh`:

```
foo/.config/foo/config   ->   ~/.config/foo/config
```

## Dev stack

`dev/env` stows to `~/env` — a docker-compose stack with Postgres (+pgvector),
MariaDB, Redis, phpMyAdmin, pgAdmin and RedisInsight.

```sh
cd ~/env && cp .env.example .env && docker compose up -d
```

## tmux only

To set up just tmux on a remote machine:

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/tdottahmed/dottfiles/main/tmux/tmux-installer/install.sh)
```
