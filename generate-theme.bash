#!/bin/bash

# Generate a tmuxtheme file depending on the supported
# colours and fonts of the terminal

# Also creates the file based on the tmux version

##########
# Config #
##########

# Blocks of data that appear on TMUX
tmux_block_left_left="#S"
tmux_block_left_middle="#(whoami)"
tmux_block_left_right="#I:#P"
tmux_block_right_left="%H:%M:%S %Z"
tmux_block_right_middle="%d/%m/%y %a"
tmux_block_right_right="#H"
# tabs
tmux_window_status_current="#I:#W#F"
tmux_window_status="#I:#W#F"

#############
# Arguments #
#############

# extract arguments to new variable names
colours_supported="$1"
unicode_supported="$2"
tmux_version_new="$3"

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

# functions for quick verification
is_unicode() {
    [[ $unicode_supported == "true" ]]
}
is_new_tmux() {
    [[ $tmux_version_new == "true" ]]
}

##########
# Script #
##########

# extract the current folder
current_folder=$(get_folder)

# theme colouring
export tmux_theme_clock_mode_style=24
export tmux_theme_status_interval=1
export tmux_theme_status_justify=centre
export tmux_theme_status_left_length=40
export tmux_theme_status_right_length=150

# initialize the colours variables with default 8 colour support
tmux_colour_white=colour7
tmux_colour_black=colour0
tmux_colour_grey=colour8

# line specific colours
tmux_line_color_activity="$tmux_colour_white"
tmux_line_status_bg="$tmux_colour_black"
tmux_line_status_fg="$tmux_colour_white"
tmux_line_status_left_left_bg="$tmux_colour_white"
tmux_line_status_left_left_fg="$tmux_colour_grey"
tmux_line_status_left_middle_bg="$tmux_colour_grey"
tmux_line_status_left_middle_fg="$tmux_colour_white"
tmux_line_status_left_right_bg="$tmux_colour_white"
tmux_line_status_left_right_fg="$tmux_colour_grey"
tmux_line_status_left_bg="$tmux_colour_white"
tmux_line_status_left_fg="$tmux_colour_grey"
tmux_line_status_right_left_bg="$tmux_colour_white"
tmux_line_status_right_left_fg="$tmux_colour_grey"
tmux_line_status_right_middle_bg="$tmux_colour_grey"
tmux_line_status_right_middle_fg="$tmux_colour_white"
tmux_line_status_right_right_bg="$tmux_colour_white"
tmux_line_status_right_right_fg="$tmux_colour_grey"
tmux_line_status_right_bg="$tmux_colour_white"
tmux_line_status_right_fg="$tmux_colour_grey"

# export the variables to envsubst
export tmux_theme_clock_mode_colour="$tmux_colour_white"
export tmux_theme_display_panes_active_colour="$tmux_colour_grey"
export tmux_theme_display_panes_colour="$tmux_colour_grey"
export tmux_theme_message_bg="$tmux_colour_grey"
export tmux_theme_message_command_bg="$tmux_colour_grey"
export tmux_theme_message_command_fg="$tmux_colour_white"
export tmux_theme_message_fg="$tmux_colour_white"
export tmux_theme_mode_bg="$tmux_colour_grey"
export tmux_theme_mode_fg="$tmux_colour_white"
export tmux_theme_pane_active_border_bg=default
export tmux_theme_pane_active_border_fg="$tmux_colour_white"
export tmux_theme_pane_border_bg=default
export tmux_theme_pane_border_fg="$tmux_colour_grey"
export tmux_theme_status_bg="$tmux_line_status_bg"
export tmux_theme_status_fg="$tmux_line_status_fg"
export tmux_theme_status_left_bg="$tmux_line_status_left_bg"
export tmux_theme_status_left_fg="$tmux_line_status_left_fg"
export tmux_theme_status_right_bg="$tmux_line_status_right_bg"
export tmux_theme_status_right_fg="$tmux_line_status_right_fg"
export tmux_theme_window_status_activity_bg="$tmux_theme_status_bg"
export tmux_theme_window_status_activity_fg="$tmux_line_color_activity"
export tmux_theme_window_status_separator=""
export tmux_theme_window_status_current_bg="$tmux_colour_white"
export tmux_theme_window_status_current_fg="$tmux_colour_grey"

# set the term variable to simply screen
term_set="screen"

# change the variables to support 256 colours
if [[ $colours_supported == "256" ]]; then
    # reset the variable with the new colours
    tmux_colour_main_1=colour245
    tmux_colour_main_2=colour250
    tmux_colour_main_3=colour245
    tmux_colour_black_1=black
    tmux_colour_grey_1=colour233
    tmux_colour_grey_2=colour235
    tmux_colour_grey_3=colour238
    tmux_colour_grey_4=colour240
    tmux_colour_grey_5=colour243
    tmux_colour_grey_6=colour245

    # line specific colours
    tmux_line_color_activity="$tmux_colour_grey_6"
    tmux_line_status_bg="$tmux_colour_grey_1"
    tmux_line_status_fg="$tmux_colour_grey_4"
    tmux_line_status_left_left_bg="$tmux_colour_main_1"
    tmux_line_status_left_left_fg="$tmux_line_status_bg"
    tmux_line_status_left_middle_bg="$tmux_line_status_fg"
    tmux_line_status_left_middle_fg="$tmux_line_status_bg"
    tmux_line_status_left_right_bg="$tmux_colour_grey_2"
    tmux_line_status_left_right_fg="$tmux_line_status_fg"
    tmux_line_status_left_bg="$tmux_colour_grey_1"
    tmux_line_status_left_fg="$tmux_colour_grey_5"
    tmux_line_status_right_left_bg="$tmux_colour_grey_2"
    tmux_line_status_right_left_fg="$tmux_line_status_fg"
    tmux_line_status_right_middle_bg="$tmux_line_status_fg"
    tmux_line_status_right_middle_fg="$tmux_line_status_bg"
    tmux_line_status_right_right_bg="$tmux_colour_grey_6"
    tmux_line_status_right_right_fg="$tmux_line_status_bg"
    tmux_line_status_right_bg="$tmux_colour_grey_1"
    tmux_line_status_right_fg="$tmux_colour_grey_5"

    # export the variables to envsubst
    export tmux_theme_clock_mode_colour="$tmux_colour_main_1"
    export tmux_theme_display_panes_active_colour="$tmux_colour_grey_6"
    export tmux_theme_display_panes_colour="$tmux_colour_grey_1"
    export tmux_theme_message_bg="$tmux_colour_main_1"
    export tmux_theme_message_command_bg="$tmux_colour_main_1"
    export tmux_theme_message_command_fg="$tmux_colour_black_1"
    export tmux_theme_message_fg="$tmux_colour_black_1"
    export tmux_theme_mode_bg="$tmux_colour_main_1"
    export tmux_theme_mode_fg="$tmux_colour_black_1"
    export tmux_theme_pane_active_border_bg=default
    export tmux_theme_pane_active_border_fg="$tmux_colour_main_1"
    export tmux_theme_pane_border_bg=default
    export tmux_theme_pane_border_fg="$tmux_colour_grey_3"
    export tmux_theme_status_bg="$tmux_line_status_bg"
    export tmux_theme_status_fg="$tmux_line_status_fg"
    export tmux_theme_status_left_bg="$tmux_line_status_left_bg"
    export tmux_theme_status_left_fg="$tmux_line_status_left_fg"
    export tmux_theme_status_right_bg="$tmux_line_status_right_bg"
    export tmux_theme_status_right_fg="$tmux_line_status_right_fg"
    export tmux_theme_window_status_activity_bg="$tmux_theme_status_bg"
    export tmux_theme_window_status_activity_fg="$tmux_line_color_activity"
    export tmux_theme_window_status_separator=""
    export tmux_theme_window_status_current_bg="$tmux_colour_black_1"
    export tmux_theme_window_status_current_fg="$tmux_colour_main_2"

    # update the TERM as needed
    term_set="screen-256color"
fi

### build the tab blocks
export tmux_theme_window_status_format="  $tmux_window_status  "

# check unicode and add block if present
temp_block=""
is_unicode && temp_block="$temp_block""#[fg=$tmux_theme_status_bg,bg=$tmux_theme_window_status_current_bg]"
temp_block="$temp_block""#[fg=$tmux_theme_window_status_current_fg,nobold] $tmux_window_status_current "
is_unicode && temp_block="$temp_block""#[fg=$tmux_theme_status_bg,bg=$tmux_theme_window_status_current_bg,nobold]"
export tmux_theme_window_status_current_format="$temp_block"

### build the left and right blocks

# build the left block
temp_block=""
temp_block="$temp_block""#[fg=$tmux_line_status_left_left_fg,bg=$tmux_line_status_left_left_bg,bold] $tmux_block_left_left "
is_unicode && temp_block="$temp_block""#[fg=$tmux_line_status_left_left_bg,bg=$tmux_line_status_left_middle_bg,nobold]"
temp_block="$temp_block""#[fg=$tmux_line_status_left_middle_fg,bg=$tmux_line_status_left_middle_bg] $tmux_block_left_middle "
is_unicode && temp_block="$temp_block""#[fg=$tmux_line_status_left_middle_bg,bg=$tmux_line_status_left_right_bg]"
temp_block="$temp_block""#[fg=$tmux_line_status_left_right_fg,bg=$tmux_line_status_left_right_bg] $tmux_block_left_right "
is_unicode && temp_block="$temp_block""#[fg=$tmux_line_status_left_right_bg,bg=$tmux_theme_status_bg,nobold]"
export tmux_theme_status_left="$temp_block"

# build the right block
temp_block=""
is_unicode && temp_block="$temp_block""#[fg=$tmux_line_status_right_left_bg,bg=$tmux_theme_status_bg]#"
temp_block="$temp_block""#[fg=$tmux_line_status_right_left_fg,bg=$tmux_line_status_right_left_bg] $tmux_block_right_left "
is_unicode && temp_block="$temp_block""#[fg=$tmux_line_status_right_middle_bg,bg=$tmux_line_status_right_left_bg]#"
temp_block="$temp_block""#[fg=$tmux_line_status_right_middle_fg,bg=$tmux_line_status_right_middle_bg] $tmux_block_right_middle "
is_unicode && temp_block="$temp_block""#[fg=$tmux_line_status_right_right_bg,bg=$tmux_line_status_right_middle_bg]#"
temp_block="$temp_block""#[fg=$tmux_line_status_right_right_fg,bg=$tmux_line_status_right_right_bg,bold] $tmux_block_right_right "
export tmux_theme_status_right="$temp_block"

# export the terminal TERM var with the default naming
echo set -g default-terminal "$term_set"

# pull the skeleton depending on the tmux version
if is_new_tmux; then
    envsubst < "$current_folder""/skeleton/new.tmuxtheme"
else
    envsubst < "$current_folder""/skeleton/old.tmuxtheme"
fi
