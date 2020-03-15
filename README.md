# My simple shell configs

Contains configs for the Bash, Xrvt-Unicode, PS lines and TMUX.

## Installation

#### Bash, TMUX and PS?

Source the `shell/shell.bash` file to your `~/.bashrc`

Before sourcing the file, environment vars can be set to `true` or `false` in order to customize the shell

 - `TMUX_START` starts tmux automatically each session if set

 - `APPLICATION_UNICODE` allows unicode support in themes if set

 - `FORCE_COLORS` allows colors to be forced to a specific number in the theme (accepts whole numbers)

##### Rxvt-Unicode

Include the path to `rxvt-unicode/urxvt.xresources` in your `~/.Xresources` file

If you want to add the font-resize extension, link the `rxvt-unicode/scripts/resize-font` to the inside of the `~/.urxvt/ext` folder 

