alias ls='ls -a --color=auto'

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

ZIM_HOME=$HOME/.config/zsh/zim
ZDOTDIR=$ZIM_HOME

if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
    https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

source ${ZIM_HOME}/init.zsh

# Forcing zsh to source my home manager variables as well.
# This can be removed if I ever decide to move my entire zsh config into nix
source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
