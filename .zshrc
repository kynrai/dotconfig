setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST 
setopt HIST_REDUCE_BLANKS

autoload -Uz compinit && compinit

[ ! -d ~/.zsh/zsh-autosuggestions ] &&  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

PROMPT="%(?.%F{green}√.%F{red}✗%?)%f %B%1~%b %# "
RPROMPT="%*"

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
SAVEHIST=10000
HISTSIZE=10000

alias ls="exa"
alias vim="nvim"
alias cat="bat"

onport() {
  lsof -t -i :$1 | xargs -n1 -I{} ps -p {} -o pid,command
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/steve/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/steve/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/steve/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/steve/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="/opt/homebrew/opt/node@16/bin:$PATH"

export PATH="/Users/steve/Library/Python/3.10/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"

source /Users/steve/.config/broot/launcher/bash/br

# bun completions
[ -s "/Users/steve/.bun/_bun" ] && source "/Users/steve/.bun/_bun"

# bun
export BUN_INSTALL="/Users/steve/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
