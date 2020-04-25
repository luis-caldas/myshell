#!/usr/bin/env bash

# My Shell

# function that finds the folder in which the script executing it is located
function get_folder() {

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

# source aliases and basic shell configs
source "$DIRECTORY_NOW""/basic.bash"

# add my tmux as an alias
alias neotmux="bash ""$DIRECTORY_NOW""/../tmux/start.bash"
alias nt="neotmux"

# source the ps1 file that is contained in the same folder
source "$DIRECTORY_NOW""/psline.bash"
