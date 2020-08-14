
# https://github.com/hanjianwei/zsh-sensible/blob/master/sensible.zsh
HISTFILE="$ZDOTDIR/.zsh_history"
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
unsetopt BEEP                    # Turn off beep

export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
zstyle ':completion::complete:*' cache-path '$ZDOTDIR/.zcompcache'

autoload -U colors && colors
autoload -U add-zsh-hook
autoload -Uz vcs_info
autoload -Uz edit-command-line
autoload -Uz compinit

set -o vi
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line
bindkey '\e.' insert-last-word

precmd_vcs_info() { vcs_info }
precmd_functions=( precmd_vcs_info )

# env {{{
export PATH="$HOME/.cargo/bin:$PATH" # rust
export EDITOR="vim"

export CLICOLORS=1 # color ls output on BSD ls

export RANGER_LOAD_DEFAULT_RC=false

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
zstyle ':vcs_info:git*:*' formats "${git_prompt_lb}%b${git_prompt_dirty}${git_prompt_rb}"
zstyle ':vcs_info:git*:*' actionformats "${git_prompt_lb}%b${git_prompt_dirty}${git_prompt_rb}${git_prompt_lb}%{$fg[yellow]%}%a${git_prompt_rb}"

PROMPT='${ret_status}${vimode} %{$fg[cyan]%}%~%{$reset_color%}%(1j.$fg[yellow](%j).) ${vcs_info_msg_0_} '

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
alias ra='ranger'
if (( $+commands[exa] )); then
  alias ls='exa'
fi

alias la='ls -la'
alias gs='git status'
alias ga='git add .'
alias bsa='brew services start'
alias bso='brew services stop'
alias bsr='brew services restart'

# }}}
# nvm {{{
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm
# NVM completion calls compinit for some reason, so it creates a new zcompdump if a custom compdump is used. It's also slow, don't use it for now.
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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
fi

# use pyenv to manage python versions
# disable this if you don't trust pyenv
if (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"
  # pyenv plugin for managing virtual envs
  (( $+commands[pyenv-virtualenv] )) && eval "$(pyenv virtualenv-init -)"
fi

# source optional configs eg. work specific env vars
if [[ -d "$ZDOTDIR" ]] && [[ -d "$ZDOTDIR/opt" ]]; then
  for file in "$ZDOTDIR"/opt/*.zsh(N); do
    source "$file"
  done
fi

# add user functions
fpath+=$ZDOTDIR/zfunc
autoload -Uz gmc load-nvmrc portkill

# check for nvmrc and change node version on dir change
add-zsh-hook chpwd load-nvmrc
load-nvmrc

compinit -d $ZDOTDIR/.zcompdump-${HOST:-'host'}-$ZSH_VERSION

