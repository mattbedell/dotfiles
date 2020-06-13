export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/opt/python/Frameworks/Python.framework/Versions/3.7/bin/python3.7:$PATH"

# -- FZF configuration --
FD_SEARCH_OPTS='--hidden --follow --exclude .git --exclude node_modules'
export FZF_DEFAULT_COMMAND="fd --type f $FD_SEARCH_OPTS"
export FZF_CTRL_T_COMMAND="fd $FD_SEARCH_OPTS"
export FZF_ALT_C_COMMAND="fd --type d $FD_SEARCH_OPTS"

export FZF_DEFAULT_OPTS='--height 80%'
#preview to FZF commands
export FZF_CTRL_T_OPTS="--preview-window 'right:60%' --preview '(bat --color=always --style=header,grid --line-range :300 {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --no-height --preview-window down:4:wrap"



autoload -U colors && colors
autoload -Uz vcs_info

# prompt {{{
local git_prompt_lb="%{$fg_bold[blue]%}[%{$fg[red]%}"
local git_prompt_rb="%{$fg_bold[blue]%}]%{$reset_color%}"
local git_prompt_dirty="%{$fg_bold[yellow]%}%u%c"
local ret_status="%(?:%{$fg_bold[blue]%}:%{$fg_bold[red]%})"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats "${git_prompt_lb}%b${git_prompt_dirty}${git_prompt_rb}"
precmd_vcs_info() { vcs_info }
precmd_functions=( precmd_vcs_info )

# }}}

setopt prompt_subst
setopt inc_append_history
setopt hist_save_no_dups
setopt hist_reduce_blanks
setopt share_history

PROMPT='${ret_status}${VIMODE} %{$fg[cyan]%}%~%{$reset_color%} ${vcs_info_msg_0_} '


# open vim with global variable set to local tty, for yanking to local machine's unnamed register
alias vi='vim -c "let g:tty='\''$(tty)'\''"'

function portkill() {
    kill -9 $(lsof -ti tcp:$1)
}


# - GIT -
alias gs='git status'
alias ga='git add .'

function gmc() {
    message=''
    branch="$(git rev-parse --abbrev-ref HEAD)"
    branch=${branch:u}
    ticket=''

    if [[ "$branch" =~ (^[[:alpha:]]{3,}-[[:digit:]]+) ]]; then
        ticket="[${match[1]}] "
    fi

    args=()
    for i in $@; do
        if [[ "$i" =~ ^- ]]; then
            args+=($i)
        else
            message="$message $i"
        fi
    done;

    #trim any leading whitespace
    message=$(expr "$message" : '[[:blank:]]*\(.*\)');

    git commit -m "$ticket$message" ${args[@]};
}

function gcane() {
    git commit --amend --no-edit
}

# - NVM -
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


#autorun nvm use
# place this after nvm initialization!
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# - VIM Shell -
export KEYTIMEOUT=1
VIMODE="►"
function zle-line-init zle-keymap-select {
  if [ $KEYMAP = vicmd ]; then
    # vim normal mode
    echo -ne "\e[2 q"
    VIMODE="○"
  else
    echo -ne "\e[6 q"
    VIMODE="►"
  fi

  zle reset-prompt
  zle -R
}

# set cursor to command mode before entering vim
function zle-line-finish {
  echo -ne "\e[2 q"
  VIMODE="▶"
}

set -o vi
zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line
bindkey '\e.' insert-last-word

# fuzzy autocompletion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

