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
setopt GLOB_DOTS                 # Do not require a leading '.' in a filename to be matched explicitly
unsetopt CASE_GLOB               # Case-insensitive matching
unsetopt BEEP                    # Turn off beep

export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZDOTDIR/.zcompcache

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
export PATH="/usr/local/sbin:$PATH" #brew
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/share/git-core/contrib/diff-highlight:/usr/share/doc/git/contrib/diff-highlight" # git inline diff, contributor script
export PATH="$PATH:$HOME/go/bin"
export MANPAGER="nvim +Man!"
export NOTES_DIR=~/Documents/notes
export VISUAL='nvim'
export BAT_THEME
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"

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
local git_prompt_lb='%B%F{blue} [%%b%F{red}'
local git_prompt_rb="%B%F{blue}]%%b%f"
local git_prompt_dirty="%F{yellow}%u%c"
local ret_status="%(?:%F{blue}:%F{red})"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git*:*' formats "${git_prompt_lb}%b${git_prompt_dirty}${git_prompt_rb}"
zstyle ':vcs_info:git*:*' actionformats "${git_prompt_lb}%b${git_prompt_dirty}${git_prompt_rb}${git_prompt_lb}%F{yellow}%a${git_prompt_rb}"

PROMPT='${ret_status}${vimode} '
PROMPT+="%F{cyan}%~%f"
PROMPT+="%F{yellow}%(1j.(%j).)%f"
PROMPT+='${vcs_info_msg_0_} '

RPROMPT="%F{242}%n@%m"

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
alias ni='nvim -c "let g:tty='\''$(tty)'\''"'
alias ra='ranger'
if (( $+commands[exa] )); then
  alias ls='exa'
fi

alias la='ls -la'
alias bsa='brew services start'
alias bso='brew services stop'
alias bsr='brew services restart'
alias k='kubectl'
alias kx='kubectx'

# }}}

# fuzzy autocompletion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf keybindings/autocompletion on linux machines
if [[ "$(uname 2> /dev/null)" == "Linux" ]]; then
  source "/usr/share/doc/fzf/examples/key-bindings.zsh" &> /dev/null
  source "/usr/share/doc/fzf/examples/completion.zsh" &> /dev/null
fi

# zsh QOL
if (( $+commands[brew] )); then
  brew_prefix=$(brew --prefix)
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" &> /dev/null
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

# this dramatically increases startup time, so remove it for now
# source optional configs eg. work specific env vars
# if [[ -d "$ZDOTDIR" ]] && [[ -d "$ZDOTDIR/opt" ]]; then
#   for file in "$ZDOTDIR"/opt/*.zsh(N); do
#     source "$file"
#   done
# fi

# add user functions
fpath+=$ZDOTDIR/zfunc
autoload -Uz portkill tmi spell lazy-nvm yankrtf vd rgp rgn

lazy-nvm

compinit -d $ZDOTDIR/.zcompdump-${HOST:-'host'}-$ZSH_VERSION

