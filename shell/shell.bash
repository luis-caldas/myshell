#!/usr/bin/env bash

# My Shell

# get the dir
DIRECTORY_NOW="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# source aliases and basic shell configs
source "$DIRECTORY_NOW""/basic.bash"

# add my tmux as an alias
alias neotmux="bash ""$DIRECTORY_NOW""/../tmux/start.bash"
alias nt="neotmux"

# source the ps1 file that is contained in the same folder
source "$DIRECTORY_NOW""/psline.bash"
