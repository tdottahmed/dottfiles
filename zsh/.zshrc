# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

# Everything else lives in ~/.config/zsh (stowed from the dotfiles repo).
ZDOTDIR_CONFIG="$HOME/.config/zsh"

source "$ZDOTDIR_CONFIG/helpers.sh"
source_files_in "$ZDOTDIR_CONFIG/aliases"
source "$ZDOTDIR_CONFIG/exports.sh"
source "$ZDOTDIR_CONFIG/ssh-agent.sh"
