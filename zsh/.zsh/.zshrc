
# https://github.com/hanjianwei/zsh-sensible/blob/master/sensible.zsh
HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.
setopt PROMPT_SUBST
setopt COMPLETE_IN_WORD          # Tries to complete in the word at the point of the cursor
setopt PATH_DIRS                 # Perform path search even on command names with slashes.
setopt EXTENDED_GLOB             # Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation
unsetopt CASE_GLOB               # Case-insensitive matching

export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

autoload -U colors && colors
autoload -U add-zsh-hook
autoload -Uz vcs_info
autoload -Uz edit-command-line

set -o vi
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line
bindkey '\e.' insert-last-word

precmd_vcs_info() { vcs_info }
precmd_functions=( precmd_vcs_info )

# env {{{
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="/usr/local/opt/python/Frameworks/Python.framework/Versions/3.7/bin/python3.7:$PATH"
export CLICOLORS=1 # color ls output on BSD ls

# FZF config {{{
FD_SEARCH_OPTS='--hidden --follow --exclude .git --exclude node_modules'
export FZF_DEFAULT_COMMAND="fd --type f $FD_SEARCH_OPTS"
export FZF_CTRL_T_COMMAND="fd $FD_SEARCH_OPTS"
export FZF_ALT_C_COMMAND="fd --type d $FD_SEARCH_OPTS"

export FZF_DEFAULT_OPTS='--height 80%'
# preview to FZF commands
export FZF_CTRL_T_OPTS="--preview-window 'right:60%' --preview '(bat --color=always --style=header,grid --line-range :300 {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --no-height --preview-window down:4:wrap"

# }}}
# }}}
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
zstyle ':vcs_info:git:*' actionformats "${git_prompt_lb}%b${git_prompt_dirty}${git_prompt_rb}${git_prompt_lb}%{$fg[yellow]%}%a${git_prompt_rb}"

PROMPT='${ret_status}${vimode} %{$fg[cyan]%}%~%{$reset_color%} ${vcs_info_msg_0_} '

# vim shell cursor and prompt {{{
export KEYTIMEOUT=1
local vimode="►"
function zle-line-init zle-keymap-select {
  if [ $KEYMAP = vicmd ]; then
    # vim normal mode
    echo -ne "\e[2 q"
    vimode="○"
  else
    echo -ne "\e[6 q"
    vimode="►"
  fi

  zle reset-prompt
  zle -R
}

# set cursor to command mode before entering vim
function zle-line-finish {
  echo -ne "\e[2 q"
  vimode="▶"
}

zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish

# }}}
# }}}
# alias {{{
# open vim with global variable set to local tty, for yanking to local machine's unnamed register
alias vi='vim -c "let g:tty='\''$(tty)'\''"'
alias gs='git status'
alias ga='git add .'

function portkill() {
    kill -9 $(lsof -ti tcp:$1)
}

# prepends [{ticket-project}-{ticket-number}] to a commit message
#
# usage: $ gmc this is a commit message
# commit message: [abc-123] this is a commit message
# @TODO make this cleaner
#
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

    # trim any leading whitespace
    message=$(expr "$message" : '[[:blank:]]*\(.*\)');

    git commit -m "$ticket$message" ${args[@]};
}

# }}}
# nvm {{{
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# }}}
# auto nvm use {{{
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

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# }}}

# fuzzy autocompletion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zsh QOL
if (( $+commands[brew] )); then
  brew_prefix=$(brew --prefix)
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" &> /dev/null
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" &> /dev/null
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH # homebrew managed autocompletions
  [ -d "$(brew --prefix)/share/zsh-completions" ] && FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# source optional configs eg. work specific env vars
if [[ -d "$ZDOTDIR" ]] && [[ -d "$ZDOTDIR/opt" ]]; then
  for file in "$ZDOTDIR"/opt/*.zsh(N); do
    source "$file"
  done
fi

