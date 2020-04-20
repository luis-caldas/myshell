#!/bin/bash

# Simple bash configurations

# aliases to my preferred configurations
alias clear_history='history -c; history -w'
alias grip='grip --user=$GIT_API_EMAIL --pass=$GIT_API_KEY --quiet'
alias nano='nano -l -E -T4'
alias cp='cp -i'
alias mv='mv -i'

# add autocompletion to the sudo command
# complete -cf sudo

# ignore commands that start with space and duplicates
export HISTCONTROL=ignoreboth

# add the color aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# add the gcc colors as well
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# change the local of the history file
export HISTFILE="${HOME}""/.cache/.bash_history"

# check if the git autocompletion file exists
if [ -f "/etc/bash_completion.d/git-prompt" ]; then
	source "/etc/bash_completion.d/git-prompt"
fi
