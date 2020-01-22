#!/bin/bash

# My Shell

#############
# Functions #
#############

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

# extract the supported number of colors from the terminal
function number_colors() {

    tput colors

}

function tmux_version() {

    # extract tmux version number
    tmux -V | grep -Po '(?<=tmux )[^a-zA-Z]+[a-zA-Z]?'

}

function tmux_newest() {

    [  "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]

}

function check_tmux() {

    # reassing argument names
    should_tmux_start="$1"

    # check if we are not inside a tmux session, or if we dont want a tmux session
    [[ $TERM != "screen"* ]] && [[ $TERM != "tmux"* ]] && [[ $should_tmux_start == true ]] && return 1

    # if reached here we are in a tmux session
    return 0

}

function start_tmux() {

    # translate argument name
    dir_now="$1"
    colors_now="$2"
    is_unicode="$3"
    is_newest="$4"

    # start tmux with the generated configs
    tmux -f <(cat "$dir_now/tmux.conf" ; bash "$dir_now""/generate-theme.bash" "$colors_now" "$is_unicode" "$is_newest")

}

#############
# Scripting #
#############

# get directory in which this script is running
DIRECTORY_NOW=$(get_folder)

# check if tmux has been started and start it if not
if ! check_tmux "$TMUX_START"; then

    # get the number of colors of this instance
    colors_now=$(number_colors)

    # check if the colors has been forced
    if [ "$FORCE_COLORS" != "" ]; then
        colors_now="$FORCE_COLORS"
    fi

    # extract the tmux version
    tmux_version=$(tmux_version)

    # check if tmux uses the new format
    # 1.9a was the version that tmux changed the syntax of the theming
    is_newest=$(tmux_newest "1.9a" "$tmux_version" && echo true || echo false)

    # if we are not in a tmux session and want one, start it
    start_tmux "$DIRECTORY_NOW" "$colors_now" "$APPLICATION_UNICODE" "$is_newest"

    # exit when tmux ends, no need to rerun code
    exit

fi

# source aliases and basic shell configs
source "$DIRECTORY_NOW""/basic.bash"

# source the ps1 file that is contained in the same folder
source "$DIRECTORY_NOW""/psline.bash"
