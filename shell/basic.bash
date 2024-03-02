#!/usr/bin/env bash

# Simple bash configurations

# My umask
umask 0077  # Only user has permissions, also no special bits

# Enable keypad mode
tput smkx

# Ignore commands that start with space and duplicates
export HISTCONTROL=ignoreboth
# Change the local of the history file
export HISTFILE="${HOME}""/.local/state/bash/history"
# Create the folder for the history if not already present
if [[ ! -e "$(dirname "$HISTFILE")" ]]; then
	mkdir -p "$(dirname "$HISTFILE")"
fi
# Sizing of the history
export HISTSIZE=1000000000
export HISTFILESIZE="$(( HISTSIZE * 1000 ))"

# Vim as preferred editor
export EDITOR="vim"

# Nix-shell force to use own PS1 line
export NIX_SHELL_PRESERVE_PROMPT="1"

# Add the gcc colors as well
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Aliases

alias cp='cp -i'
alias mv='mv -i'
alist rm='rm -i'

# Add colour aliases
alias ls='ls --group-directories-first --color=auto'
alias grep='grep --color=auto'

# VIM aliases
alias vi='vi -p'
alias vim='vim -p'
alias nvim='nvim -p'

# Clock
alias clock='tty-clock -c -b -s'

# Alias python http server to a simpler command
alias phttpd='python -m SimpleHTTPServer'

# Alias for unmount
alias unmount='umount'

# Aliases to my preferred configurations
alias flush='history -c; history -w'
alias grip='grip --user=$GIT_API_EMAIL --pass=$GIT_API_KEY --quiet'
alias nano='nano -l -E -T4'

# Shortening commands

# Open
alias x='xdg-open'

# Tmux aliases
alias na='tmux a'
alias nat='tmux a -t'

# Some NixOS aliases
alias reb='nixos-rebuild boot --option tarball-ttl 0'
alias rebu='nixos-rebuild boot --upgrade --option tarball-ttl 0'
alias sreb='sudo nixos-rebuild boot --option tarball-ttl 0'
alias srebu='sudo nixos-rebuild boot --upgrade --option tarball-ttl 0'
alias resw='nixos-rebuild switch --option tarball-ttl 0'
alias reswu='nixos-rebuild switch --upgrade --option tarball-ttl 0'
alias sresw='sudo nixos-rebuild switch --option tarball-ttl 0'
alias sreswu='sudo nixos-rebuild switch --upgrade --option tarball-ttl 0'

# Check if the git autocompletion file exists
if [ -f "/etc/bash_completion.d/git-prompt" ]; then
	source "/etc/bash_completion.d/git-prompt"
fi
