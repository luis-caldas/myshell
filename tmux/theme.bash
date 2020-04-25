#!/usr/bin/env bash
# vim: ft=bash:foldmethod=marker:expandtab:ts=4:shiftwidth=4


# Generate a tmuxtheme file depending on the supported
# colours and fonts of the terminal

# Also creates the theme based on the tmux version

# {{{ Config #

# blocks of data that appear on TMUX
t_block_l_l="#S"
t_block_l_m="#(whoami)"
t_block_l_r="#I:#P"
t_block_r_l="%H:%M:%S %Z"
t_block_r_m="%d/%m/%y %a"
t_block_r_r="#H"

# tabs
t_window_status_current="#I:#W#F"
t_window_status="#I:#W#F"

# unicode symbols
arrow_left=""
arrow_left_hollow=""
arrow_right=""
arrow_right_hollow=""

# }}}

# {{{ Arguments

# extract arguments to new variable names
colours_supported="$1"
unicode_supported="$2"
tmux_version_new="$3"

# }}}

# {{{ Functions

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
# is_unicode
iu() {
    [[ $unicode_supported == "true" ]]
}
is_new_tmux() {
    [[ $tmux_version_new == "true" ]]
}

# }}}

# {{{ Main

# extract the current folder
current_folder=$(get_folder)
compatibility_folder="$current_folder""/compatibility"

# theme colouring
export tmux_theme_clock_mode_style=24
export tmux_theme_status_interval=1
export tmux_theme_status_justify=centre
export tmux_theme_status_left_length=40
export tmux_theme_status_right_length=150
export tmux_theme_window_status_separator=""

# {{{ Colours

# general colouring
t_back=terminal
t_def=default

# initialize the colours variables with default 8 colour support
t_white=colour7
t_black=colour0

# initialize all more complex colours
t_c_grey_1=colour233
t_c_grey_2=colour235
t_c_grey_3=colour238
t_c_grey_4=colour240
t_c_grey_5=colour243
t_c_grey_6=colour245
t_c_grey_7=colour250

# }}}

# {{{ Variable Assingment

# line specific colours
# that will help when building the bottom status line
t_line_ca="$t_white"
t_line_bg="$t_back"
t_line_fg="$t_white"
t_line_l_l_bg="$t_white"
t_line_l_l_fg="$t_black"
t_line_l_m_bg="$t_black"
t_line_l_m_fg="$t_white"
t_line_l_r_bg="$t_white"
t_line_l_r_fg="$t_black"
t_line_m_bg="$t_white"

# export the variables to envsubst
export tmux_theme_clock_mode_colour="$t_white"
export tmux_theme_display_panes_active_colour="$t_black"
export tmux_theme_display_panes_colour="$t_white"
export tmux_theme_message_bg="$t_white"
export tmux_theme_message_command_bg="$t_white"
export tmux_theme_message_command_fg="$t_black"
export tmux_theme_message_fg="$t_black"
export tmux_theme_mode_bg="$t_white"
export tmux_theme_mode_fg="$t_black"
export tmux_theme_pane_active_border_bg="$t_def"
export tmux_theme_pane_active_border_fg="$t_white"
export tmux_theme_pane_border_bg="$t_def"
export tmux_theme_pane_border_fg="$t_white"
export tmux_theme_status_bg="$t_line_bg"
export tmux_theme_status_fg="$t_line_fg"
export tmux_theme_window_status_activity_bg="$t_line_bg"
export tmux_theme_window_status_activity_fg="$t_line_ca"
export tmux_theme_window_status_current_bg="$t_white"
export tmux_theme_window_status_current_fg="$t_black"

# bolding of the blocks of the tmux theme
t_bold_l_l="nobold" 
t_bold_l_m="nobold"
t_bold_l_r="nobold"
t_bold_m="nobold"

# set the term variable to simply screen
term_set="screen"

# change the variables to support 256 colours
if [[ $colours_supported == "256" ]]; then

    # line specific colours
    t_line_ca="$t_c_grey_6"
    t_line_bg="$t_back"
    t_line_fg="$t_c_grey_4"
    t_line_l_l_bg="$t_c_grey_7"
    t_line_l_l_fg="$t_c_grey_1"
    t_line_l_m_bg="$t_c_grey_6"
    t_line_l_m_fg="$t_c_grey_1"
    t_line_l_r_bg="$t_c_grey_2"
    t_line_l_r_fg="$t_c_grey_7"
    t_line_m_bg="$t_c_grey_1"

    # export the variables to envsubst
    export tmux_theme_clock_mode_colour="$t_c_grey_6"
    export tmux_theme_display_panes_active_colour="$t_c_grey_6"
    export tmux_theme_display_panes_colour="$t_c_grey_1"
    export tmux_theme_message_bg="$t_c_grey_6"
    export tmux_theme_message_command_bg="$t_c_grey_6"
    export tmux_theme_message_command_fg="$t_black"
    export tmux_theme_message_fg="$t_black"
    export tmux_theme_mode_bg="$t_c_grey_6"
    export tmux_theme_mode_fg="$t_black"
    export tmux_theme_pane_active_border_bg="$t_def"
    export tmux_theme_pane_active_border_fg="$t_c_grey_7"
    export tmux_theme_pane_border_bg="$t_def"
    export tmux_theme_pane_border_fg="$t_c_grey_3"
    export tmux_theme_status_bg="$t_line_bg"
    export tmux_theme_status_fg="$t_line_fg"
    export tmux_theme_window_status_activity_bg="$t_line_bg"
    export tmux_theme_window_status_activity_fg="$t_line_ca"
    export tmux_theme_window_status_current_bg="$t_c_grey_1"
    export tmux_theme_window_status_current_fg="$t_c_grey_7"

    # bolding of the blocks of the tmux theme
    t_bold_l_l="bold" 
    t_bold_l_m="nobold"
    t_bold_l_r="nobold"
    t_bold_m="nobold"

    # update the TERM as needed
    term_set="screen-256color"
fi

# }}}

# {{{ Block building

# mirror the colours and boldness set for the left of the status line
t_line_r_l_bg="$t_line_l_r_bg"
t_line_r_l_fg="$t_line_l_r_fg"
t_line_r_m_bg="$t_line_l_m_bg"
t_line_r_m_fg="$t_line_l_m_fg"
t_line_r_r_bg="$t_line_l_l_bg"
t_line_r_r_fg="$t_line_l_l_fg"
t_bold_r_l="$t_bold_l_r"
t_bold_r_m="$t_bold_l_m"
t_bold_r_r="$t_bold_l_l"

### build the tab blocks
export tmux_theme_window_status_format="  $t_window_status  "

# check unicode and add block if present
_tb=""
iu && _tb="$_tb""#[fg=$t_line_m_bg,bg=$t_back,nobold]$arrow_left"
_tb="$_tb""#[fg=$tmux_theme_window_status_current_fg,bg=$t_line_m_bg,$t_bold_m] $t_window_status_current "
iu && _tb="$_tb""#[fg=$t_line_m_bg,bg=$t_back,nobold]$arrow_right"
export tmux_theme_window_status_current_format="$_tb"

### build the left and right blocks

# build the left block
_tb=""
iu && _tb="$_tb""#[fg=$t_line_l_l_bg,bg=$t_back,nobold]$arrow_left"
_tb="$_tb""#[fg=$t_line_l_l_fg,bg=$t_line_l_l_bg,$t_bold_l_l] $t_block_l_l "
iu && _tb="$_tb""#[fg=$t_line_l_l_bg,bg=$t_line_l_m_bg,nobold]$arrow_right"
_tb="$_tb""#[fg=$t_line_l_m_fg,bg=$t_line_l_m_bg,$t_bold_l_m] $t_block_l_m "
iu && _tb="$_tb""#[fg=$t_line_l_m_bg,bg=$t_line_l_r_bg,nobold]$arrow_right"
_tb="$_tb""#[fg=$t_line_l_r_fg,bg=$t_line_l_r_bg,$t_bold_l_r] $t_block_l_r "
iu && _tb="$_tb""#[fg=$t_line_l_r_bg,bg=$t_back,nobold]$arrow_right"
export tmux_theme_status_left="$_tb"

# build the right block
_tb=""
iu && _tb="$_tb""#[fg=$t_line_r_l_bg,bg=$t_back,nobold]$arrow_left"
_tb="$_tb""#[fg=$t_line_r_l_fg,bg=$t_line_r_l_bg,$t_bold_r_l] $t_block_r_l "
iu && _tb="$_tb""#[fg=$t_line_r_m_bg,bg=$t_line_r_l_bg,nobold]$arrow_left"
_tb="$_tb""#[fg=$t_line_r_m_fg,bg=$t_line_r_m_bg,$t_bold_r_m] $t_block_r_m "
iu && _tb="$_tb""#[fg=$t_line_r_r_bg,bg=$t_line_r_m_bg,nobold]$arrow_left"
_tb="$_tb""#[fg=$t_line_r_r_fg,bg=$t_line_r_r_bg,$t_bold_r_r] $t_block_r_r "
iu && _tb="$_tb""#[fg=$t_line_r_r_bg,bg=$t_back,nobold]$arrow_right"
export tmux_theme_status_right="$_tb"

# }}}

# export the terminal TERM var with the default naming
echo set -g default-terminal "$term_set"

# pull the skeleton depending on the tmux version
if is_new_tmux; then
    envsubst < "$compatibility_folder""/new.tmuxtheme"
else
    envsubst < "$compatibility_folder""/old.tmuxtheme"
fi

# }}}
