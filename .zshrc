setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST 
setopt HIST_REDUCE_BLANKS

PROMPT="%(?.%F{green}√.%F{red}✗%?)%f %B%1~%b %# "
RPROMPT="%*"

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
SAVEHIST=10000
HISTSIZE=10000

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

[ ! -f ~/.config/helix/config.toml ] && mkdir -p ~/.config/helix && curl --fail -o ~/.config/helix/config.toml https://raw.githubusercontent.com/kynrai/dotconfig/refs/heads/master/helix/config.toml

[ ! -f ~/.config/bat/config ] && mkdir -p ~/.config/bat && curl --fail -o ~/.config/bat/config https://raw.githubusercontent.com/kynrai/dotconfig/refs/heads/master/bat/config
[ ! -f ~/.config/bat/themes/CatppuccinMocha.tmTheme ] && mkdir -p ~/.config/bat/themes && curl --fail -o ~/.config/bat/themes/CatppuccinMocha.tmTheme https://raw.githubusercontent.com/kynrai/dotconfig/refs/heads/master/bat/themes/CatppuccinMocha.tmTheme

[ ! -f ~/.config/ghostty/config ] && mkdir -p ~/.config/ghostty && curl --fail -o ~/.config/ghostty/config https://raw.githubusercontent.com/kynrai/dotconfig/refs/heads/master/ghostty/config]
[ ! -f ~/.config/ghostty/themes/catppuccin-mocha ] && mkdir -p ~/.config/ghostty/themes && curl --fail -o ~/.config/ghostty/themes/catppuccin-mocha https://raw.githubusercontent.com/kynrai/dotconfig/refs/heads/master/ghostty/themes/catppuccin-mocha

[ ! -f ~/.config/starship.toml ] && mkdir -p ~/.config && curl --fail -o ~/.config/starship.toml https://raw.githubusercontent.com/kynrai/dotconfig/refs/heads/master/starship.toml
eval "$(starship init zsh)"

if type "exa" > /dev/null; then
  alias ls="exa -als type"
fi

if type "bat" > /dev/null; then
  alias cat="bat"
fi

onport() {
  lsof -t -i :$1 | xargs -n1 -I{} ps -p {} -o pid,command
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

