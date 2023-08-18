#!/usr/bin/env bash

# My Shell

# {{{ Functions

# Extract the supported number of colors from the terminal
function number_colors() {
    tput colors
}

# Extract the current tmux version
function tmux_version() {

    # Extract tmux version number
    tmux -V | grep -Po '(?<=tmux )[^a-zA-Z]+[a-zA-Z]?'

}

# Function used to compare versioning of applications
function tmux_newest() {

    [  "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]

}

function check_tmux() {

    # Reassign argument names
    should_tmux_start="$1"

    # Check if we are not inside a tmux session, or if we dont want a tmux session
    [[ $TERM != "screen"* ]] && [[ $TERM != "tmux"* ]] && [[ $should_tmux_start == true ]] && return 1

    # If reached here we are in a tmux session
    return 0

}

function start_tmux() {

    # Translate argument name

    # The directory in which the theme generator and config are located
    tmux_directory="$1"

    # The number of colors supported by the terminal
    colors_now="$2"

    # Check if the application was forced to be in unicode
    is_unicode="$3"

    # Check which tmux version we are running so the theme generator can generate a proper theme
    is_newest="$4"

    # Start tmux with the generated configs
    tmux -f <(cat "$tmux_directory""/tmux.conf" ; bash "$tmux_directory""/theme.bash" "$colors_now" "$is_unicode" "$is_newest") "${@:5}"

}

# }}}

# Get directory in which this script is running
DIRECTORY_NOW="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# Get the number of colors of this instance
colors_now=$(number_colors)

# Check if the colors has been forced
if [ "$FORCE_COLOURS" != "" ]; then
    colors_now="$FORCE_COLOURS"
fi

# Extract the tmux version
tmux_version=$(tmux_version)

# Check if tmux uses the new format
# 1.9a was the version that tmux changed the syntax of the theming
is_newest=$(tmux_newest "1.9a" "$tmux_version" && echo true || echo false)

# If we are not in a tmux session and want one, start it
start_tmux "$DIRECTORY_NOW" "$colors_now" "$APPLICATION_UNICODE" "$is_newest" "$@"

