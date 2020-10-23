#!/usr/bin/env bash

# Simple bash configurations

# aliases to my preferred configurations
alias flush='history -c; history -w'
alias grip='grip --user=$GIT_API_EMAIL --pass=$GIT_API_KEY --quiet'
alias nano='nano -l -E -T4'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vi -p'
alias vim='vim -p'
alias nvim='nvim -p'

# enable keypad mode
tput smkx

# ignore commands that start with space and duplicates
export HISTCONTROL=ignoreboth

# change the local of the history file
export HISTFILE="${HOME}""/.cache/.bash_history"

# vim as preferred editor
export EDITOR="vim"

# add the color aliases
alias ls='ls --group-directories-first --color=auto'
alias grep='grep --color=auto'

# some nixos aliases
alias resw='nixos-rebuild switch --option tarball-ttl 0'
alias sresw='sudo nixos-rebuild switch --option tarball-ttl 0'

# Alias python http server to a simpler command
alias phttpd='python -m SimpleHTTPServer'

# add the gcc colors as well
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# check if the git autocompletion file exists
if [ -f "/etc/bash_completion.d/git-prompt" ]; then
	source "/etc/bash_completion.d/git-prompt"
fi
