#!/usr/bin/env bash

# Local binaries
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.local/share/bin:$PATH"

# Composer global binaries
export PATH="$PATH:$HOME/.config/composer/vendor/bin"

# Mason (neovim LSP/tool installer)
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"

# Go
export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"

# Input method (ibus)
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

export EDITOR=nvim
export VISUAL=nvim

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
