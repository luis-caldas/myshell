#!/bin/bash

# simple bash script that activates tmux, color and my ps1 line

# function that finds the folder in which the script executing it is located
get_folder() {

    # get the folder in which the script is located
    SOURCE="${BASH_SOURCE[0]}"

    # resolve $SOURCE until the file is no longer a symlink
    while [ -h "$SOURCE" ]; do

      DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

      SOURCE="$(readlink "$SOURCE")"

      # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"

    done

    # the final assignment of the directory
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

    # return the directory
    echo "$DIR"
}

# aliases to my preferred configurations
alias clear_history='history -c; history -w'
alias grip='grip --user=$GIT_API_EMAIL --pass=$GIT_API_KEY --quiet'
alias nano='nano -l -E -T4'
alias cp='cp -i'
alias mv='mv -i'

# add autocompletion to the sudo command
complete -cf sudo

# add the color aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# add the gcc colors as well
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# check if the git autocompletion file exists
if [ -f "/etc/bash_completion.d/git-prompt" ]; then
	source "/etc/bash_completion.d/git-prompt"
fi

# get the folder of this script
DIRECTORY_NOW=$(get_folder)

# start tmux of not on ssh and if the variable TMUX_START is set and true
# the command to start the terminal must set the variable needed to true example
# bash -c 'export TMUX_START=true; {terminal of choice}'
[[ $TERM != "screen" ]]  && [[ $TMUX_START == true ]] && exec tmux -f <(cat "$DIRECTORY_NOW/tmux.conf" ; echo "source-file \"$DIRECTORY_NOW/gray.tmuxtheme\"")

# source the ps1 file that is contained in the same folder
source "$DIRECTORY_NOW/myps1.bash"
