#!/usr/bin/env bash

######################################################
# a simple ps1 line for a good looking bash terminal #
######################################################

# create the color array using tput
RAW_COLORS=(
	"$(tput setaf 1)"  # red         0
	"$(tput setaf 2)"  # green       1
	"$(tput setaf 3)"  # yellow      2
	"$(tput setaf 4)"  # blue        3
	"$(tput setaf 5)"  # purple      4
	"$(tput setaf 6)"  # cyan        5
	"$(tput setaf 7)"  # gray        6
	"$(tput bold)"     # bold        7
	"$(tput smul)"     # underlined  8
	"$(tput blink)"    # blinking    9
	"$(tput sgr0)"     # reset       10
)

####################
# global variables #
####################

# colors in numbers
USER_NAME_COLOR=1
HOSTNAME_COLOR=2
DIRECTORY_COLOR=5
TIME_DATE_COLOR=2
TIME_LINE_COLOR=1
GIT_COLOR=4
COMMAND_CODE_GOOD_COLOR=1
COMMAND_CODE_BAD_COLOR=0
BASH_SYMBOL="$"

# variables that change for root
if [[ $EUID -eq 0 ]]; then
	OLD_USER_NAME=$USER_NAME_COLOR
	USER_NAME_COLOR=$HOSTNAME_COLOR
	HOSTNAME_COLOR=$OLD_USER_NAME
	BASH_SYMBOL="#"
fi

####################

# characters to help count the non printing characters
LIMITERS=( "\001" "\002" )

# iterate over the raw colors and add the limiters
for (( loop_index = 0; loop_index <= ${#RAW_COLORS[@]} + 1; loop_index++ )); do
	COLORS[$loop_index]="${LIMITERS[0]}${RAW_COLORS[$loop_index]}${LIMITERS[1]}"
done

USER_HOSTNAME="${COLORS[7]}${COLORS[$USER_NAME_COLOR]}\u${COLORS[10]}${COLORS[7]}@${COLORS[$HOSTNAME_COLOR]}\h${COLORS[10]}"

# dir in which the bash is
DIR_NOW="${COLORS[7]}${COLORS[$DIRECTORY_COLOR]}\w${COLORS[10]}"

# bash symbol
BASH_SYMBOL_BOLD="${COLORS[7]}$BASH_SYMBOL${COLORS[10]}"

# create the directory tab
DIRECTORY_TAB="${COLORS[7]}[${COLORS[10]}$DIR_NOW${COLORS[7]}]${COLORS[10]}"

# build the power combo
POWER_COMBO="${COLORS[7]}[${COLORS[10]}$USER_HOSTNAME${COLORS[7]}]${COLORS[10]}"

# build the jobs tab
JOBS_INFO="${COLORS[7]}[${COLORS[10]}\j${COLORS[7]}]${COLORS[10]}"

# build the bash version tab
BASH_VERSION="${COLORS[7]}[${COLORS[10]}\V${COLORS[7]}]${COLORS[10]}"

# build the history and command number tab
HISTORY_COMMAND="${COLORS[7]}[${COLORS[10]}!\!${COLORS[7]}|${COLORS[10]}#\#${COLORS[7]}]${COLORS[10]}"

# build the function that will print the color base on the successfulness of the previous command
get_color() {
	if [ "$SUCCESS_CODE" = "0" ]; then
		printf "%b" "${COLORS[$COMMAND_CODE_GOOD_COLOR]}"
	else
		printf "%b" "${COLORS[$COMMAND_CODE_BAD_COLOR]}"
	fi
}

# function to print the success code
print_success() {
	printf "%s" "$SUCCESS_CODE"
}

# build the function that will show the git information if the command in present
maybe_git() {
	# git command name
	GIT_COMMAND="git"

	# print trailing space
	printf "%s" " "

	# check if the command exists and if exists print it
	if type "${GIT_COMMAND}" &> /dev/null; then

		# Extract name of the branch
		GIT_RESULT="$("$GIT_COMMAND" branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"

		if [ -n "$GIT_RESULT" ]; then
			printf "${COLORS[7]}[${COLORS[$GIT_COLOR]}$GIT_RESULT${COLORS[10]}${COLORS[7]}]${COLORS[10]} "
		fi

	fi
}

# build the date line
TIME_DATE="${COLORS[7]}${COLORS[$TIME_DATE_COLOR]}$(date +"%Y/%m/%d")${COLORS[10]}"

# build the time line
TIME_TIME="${COLORS[7]}${COLORS[$TIME_LINE_COLOR]}$(date +"%H:%M:%S")${COLORS[10]}"

# buid the date brackets
TIME_DATE_LINE="${COLORS[7]}[${COLORS[10]}$TIME_DATE${COLORS[7]}]${COLORS[10]}"

# build the time brackets
TIME_LINE="${COLORS[7]}[${COLORS[10]}$TIME_TIME${COLORS[7]}]${COLORS[10]}"

# build the success tab
SUCCESSFULNESS="${COLORS[7]}[${COLORS[10]}\$(get_color)\$(print_success)${COLORS[10]}${COLORS[7]}]${COLORS[10]}"

# build the whole time line
TIME="$TIME_DATE_LINE $TIME_LINE $SUCCESSFULNESS"

# build the information line
INFORMATION_LINE="$POWER_COMBO $DIRECTORY_TAB\$(maybe_git)$BASH_SYMBOL_BOLD"

# build the line in which the command will be executed
COMMAND_LINE="$BASH_SYMBOL_BOLD ${COLORS[7]}>${COLORS[10]} "

# command line for ps2
COMMAND_LINE_PS2="${COLORS[7]}  >${COLORS[10]} "

# the save the success code
PROMPT_COMMAND="SUCCESS_CODE=\$?"

# final ps1 assignment
PS1="$TIME\n$INFORMATION_LINE\n$COMMAND_LINE"

# assign ps2 as well while we're at it
PS2="$COMMAND_LINE_PS2"
