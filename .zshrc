setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST 
setopt HIST_REDUCE_BLANKS

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

[ ! -d ~/.zsh/zsh-autosuggestions ] &&  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

[ ! -d ~/.zsh/zsh-syntax-highlighting ] &&  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

update_zsh() {
    for dir in ~/.zsh/*; do
        echo "Updating $dir"
        [ -d "$dir" ] && git -C "$dir" pull
    done
}
PROMPT="%(?.%F{green}√.%F{red}✗%?)%f %B%1~%b %# "
RPROMPT="%*"

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
SAVEHIST=10000
HISTSIZE=10000

alias ls="exa -als type"
alias cat="bat"


onport() {
  lsof -t -i :$1 | xargs -n1 -I{} ps -p {} -o pid,command
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"

