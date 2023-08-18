#!/usr/bin/env bash

# My Shell

# Get the dir
DIRECTORY_NOW="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# Source aliases and basic shell configs
source "${DIRECTORY_NOW}/basic.bash"

# Add my tmux as an alias
alias neotmux="bash ${DIRECTORY_NOW}/../tmux/start.bash"
alias nt="neotmux"

# Source the ps1 file that is contained in the same folder
source "${DIRECTORY_NOW}/psline.bash"
