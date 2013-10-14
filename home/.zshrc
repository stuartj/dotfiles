# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt  autocd extendedglob
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/stuart/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# aliases for color setup in prompts
autoload -U colors && colors

# server prompt per bash-config
PS1="%{$fg_bold[green]%}%m @ %D{%a %R}%{$fg_bold[blue]%} %~ $%{$reset_color%} "

# share history across all Zsh sessions, ignoring duplicates
setopt share_history histignorealldups

export EDITOR=vi

### {{{ vi-mode configuration

# set vi-mode
bindkey -v

# allow command-line editing in external editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line # ESC-v to edit in an external editor.

# vi-style search
bindkey -M vicmd "?" history-incremental-search-backward
bindkey -M vicmd "/" history-incremental-search-forward

# arrow keys browse *or* search
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

## bash emacs-mode compatibility
# Ctl-R searching
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
# Alt-. to insert previous last argument
bindkey '\e.' insert-last-word

# Accept RETURN in vi command mode.
function accept_line {
  RPS1=""
  RPS2=$RPS1
  zle reset-prompt
  builtin zle .accept-line
}
zle -N accept_line
bindkey -M vicmd "^M" accept_line # Allow RETURN in vi command.

# highlight when in vi-command mode
# from http://stackoverflow.com/questions/3622943/zsh-vi-mode-status-line
function zle-line-init zle-keymap-select {
    RPS1="%{$bg_bold[white]$fg_bold[black]%}${${KEYMAP/vicmd/-- COMMAND --}/(main|viins)/}%{$reset_color%}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# toggle to normal/'edit' mode with jj
bindkey -M viins 'jj' vi-cmd-mode

# allow Delete key to work in insert mode
bindkey -M viins '^?'  backward-delete-char

## }}}

## GNU screen worarounds
# turn off SIGQUIT (for using C-\ in meta-screen)
stty quit undef
# disable flow control from keyboard (fix for Ctl-S in screen halting flow)
stty ixoff -ixon

#############################################
# configure to start ssh-agent to handle ssh passphrase
# per http://help.github.com/ssh-key-passphrases/

SSH_ENV="$HOME/.ssh/environment"

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    echo succeeded
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
    ssh-add
}

# test for identities
function test_identities {
    # test whether standard identities have been added to the agent already
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $? -eq 0 ]; then
        ssh-add
        # $SSH_AUTH_SOCK broken so we start a new proper agent
        if [ $? -eq 2 ];then
            start_agent
        fi
    fi
}

# check for running ssh-agent with proper $SSH_AGENT_PID
if [ -n "$SSH_AGENT_PID" ]; then
    ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent > /dev/null
    if [ $? -eq 0 ]; then
  test_identities
    fi
# if $SSH_AGENT_PID is not properly set, we might be able to load one from
# $SSH_ENV
else
    if [ -f "$SSH_ENV" ]; then
  . "$SSH_ENV" > /dev/null
    fi
    ps -ef | grep "$SSH_AGENT_PID" | grep -v grep | grep ssh-agent > /dev/null
    if [ $? -eq 0 ]; then
        test_identities
    else
        start_agent
    fi
fi

#     source ~/.localinclude
#     fi]

### PAM config

# set JAVA_HOME for e.g. compiling rjb
export JAVA_HOME=/usr/java/jdk1.6.0_45
export PATH=$PATH:$JAVA_HOME/bin

# common Alliantist developer scripts
export PAM=~/git/PAM
export PAM_SCRIPTS=~/git/scripts

export PATH=$PATH:$PAM_SCRIPTS/bin
export PATH=$PATH:$PAM_SCRIPTS/bin/load_test
source $PAM_SCRIPTS/bin/bash/.aliases

# use a non-standard env not committed to git
export RAILS_ENV=dev-cached

# personal aliases and functions
alias gs='git status'
alias gb='git branch'
#alias gcb="git branch | grep '\\*' | cut -c 3-"
alias gai='git add -i'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gm='git mergetool --no-prompt'
alias grc='git rebase --continue'
alias gpr='git fetch origin && git pull --rebase origin `gcb`'
alias gpo='git push --tags origin `gcb`'
alias glr='git log reviewed..master --color -p --reverse'
alias grgrep='git remote show origin | grep '
alias gds='git difftool --staged'
alias tob='git fetch origin && tig HEAD..origin/`gcb`'
alias gri='git rebase -i origin/master'
alias pryc='cdp && bundle exec pry -r ./config/environment'
alias ts='tig status'
alias gcb="git symbolic-ref HEAD 2>/dev/null | sed -e 's@refs/heads/@@'"

alias taggenerate="ctags -R --exclude=.git --exclude=log --languages=Ruby * \
                                           $GEM_HOME/gems/rails-2.3.5 \
                                           $GEM_HOME/gems/activerecord-2.3.5 \
                                           $GEM_HOME/gems/activeresource-2.3.5 \
                                           $GEM_HOME/gems/activesupport-2.3.5 \
                                           $GEM_HOME/gems/actionmailer-2.3.5 \
                                           $GEM_HOME/gems/actionpack-2.3.5 \
                                           $GEM_HOME/gems/authlogic-2.1.6"

## User functions
# convenience to clear out database before loading dumpfile
function dbclear () {
  MYSQL="mysql -D $*"
  $=MYSQL -BNe "show tables" | awk '{print "set foreign_key_checks=0; drop table `" $1 "`;"}' | $=MYSQL
  unset MYSQL
}

# complete words from tmux pane(s) {{{1
# Source: http://blog.plenz.com/2012-01/zsh-complete-words-from-tmux-pane.html
_tmux_pane_words() {
  local expl
  local -a w
  if [[ -z "$TMUX_PANE" ]]; then
    _message "not running inside tmux!"
    return 1
  fi
  # capture current pane first
  w=( ${(u)=$(tmux capture-pane -J -p)} )
  for i in $(tmux list-panes -F '#P'); do
    # skip current pane (handled above)
    [[ "$TMUX_PANE" = "$i" ]] && continue
    w+=( ${(u)=$(tmux capture-pane -J -p -t $i)} )
  done
  _wanted values expl 'words from current tmux pane' compadd -a w
}

zle -C tmux-pane-words-prefix complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^X^X' tmux-pane-words-prefix
bindkey '^X^T' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
# display the (interactive) menu on first execution of the hotkey
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' menu yes select interactive
zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'
# }}}

# localise
if [[ -r ~/.local.zshrc ]]; then
    source ~/.local.zshrc
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
