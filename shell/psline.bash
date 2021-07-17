#!/usr/bin/env bash

######################################################
# a simple ps1 line for a good looking bash terminal #
######################################################

# create the color array using tput
RAW_COLOURS=(
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

# normal naming variable
SSH_MESSAGE="SSH Connection"

# colors in numbers
USER_NAME_COLOUR=1
HOSTNAME_COLOUR=2
DIRECTORY_COLOUR=5
TIME_DATE_COLOUR=2
TIME_LINE_COLOUR=1
GIT_COLOUR=4
SSH_WARNING_COLOUR=7
SSH_DOMAIN_COLOUR=2
SSH_PORT_COLOUR=1
COMMAND_CODE_GOOD_COLOUR=1
COMMAND_CODE_BAD_COLOUR=0
BASH_SYMBOL="$"

# variables that change for root
if [[ $EUID -eq 0 ]]; then
	OLD_USER_NAME=$USER_NAME_COLOUR
	USER_NAME_COLOUR=$HOSTNAME_COLOUR
	HOSTNAME_COLOUR=$OLD_USER_NAME
	BASH_SYMBOL="#"
fi

####################

# characters to help count the non printing characters
LIMITERS=( "\001" "\002" )

# iterate over the raw colors and add the limiters
for (( loop_index = 0; loop_index <= ${#RAW_COLOURS[@]} + 1; loop_index++ )); do
	COLOURS[$loop_index]="${LIMITERS[0]}${RAW_COLOURS[$loop_index]}${LIMITERS[1]}"
done

USER_HOSTNAME="${COLOURS[7]}${COLOURS[$USER_NAME_COLOUR]}\u${COLOURS[10]}${COLOURS[7]}@${COLOURS[$HOSTNAME_COLOUR]}\h${COLOURS[10]}"

# dir in which the bash is
DIR_NOW="${COLOURS[7]}${COLOURS[$DIRECTORY_COLOUR]}\w${COLOURS[10]}"

# bash symbol
BASH_SYMBOL_BOLD="${COLOURS[7]}$BASH_SYMBOL${COLOURS[10]}"

# create the directory tab
DIRECTORY_TAB="${COLOURS[7]}[${COLOURS[10]}$DIR_NOW${COLOURS[7]}]${COLOURS[10]}"

# build the power combo
POWER_COMBO="${COLOURS[7]}[${COLOURS[10]}$USER_HOSTNAME${COLOURS[7]}]${COLOURS[10]}"

# build the jobs tab
JOBS_INFO="${COLOURS[7]}[${COLOURS[10]}\j${COLOURS[7]}]${COLOURS[10]}"

# build the bash version tab
BASH_VERSION="${COLOURS[7]}[${COLOURS[10]}\V${COLOURS[7]}]${COLOURS[10]}"

# build the history and command number tab
HISTORY_COMMAND="${COLOURS[7]}[${COLOURS[10]}!\!${COLOURS[7]}|${COLOURS[10]}#\#${COLOURS[7]}]${COLOURS[10]}"

# build the function that will print the color base on the successfulness of the previous command
get_color() {
	if [ "$SUCCESS_CODE" = "0" ]; then
		printf "%b" "${COLOURS[$COMMAND_CODE_GOOD_COLOUR]}"
	else
		printf "%b" "${COLOURS[$COMMAND_CODE_BAD_COLOUR]}"
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
			echo -e "${COLOURS[7]}[${COLOURS[$GIT_COLOUR]}$GIT_RESULT${COLOURS[10]}${COLOURS[7]}]${COLOURS[10]} "
		fi

	fi
}

# generate the shell line if we are on a ssh connection
ssh_line() {

	# extract data from the ssh variable
	domain="$(awk '{ print $1 }' <<< "$SSH_CLIENT")"
	port="$(awk '{ print $3 }' <<< "$SSH_CLIENT")"

	# create the proper parts of the line
	warning_part="${COLOURS[7]}${COLOURS[$SSH_WARNING_COLOUR]}$SSH_MESSAGE${COLOURS[10]}"
	domain_part="${COLOURS[7]}${COLOURS[$SSH_DOMAIN_COLOUR]}$domain${COLOURS[10]}"
	port_part="${COLOURS[7]}${COLOURS[$SSH_PORT_COLOUR]}$port${COLOURS[10]}"

	# build the brackets around the data
	warning_part_brackets="${COLOURS[7]}[${COLOURS[10]}$warning_part${COLOURS[7]}]${COLOURS[10]}"
	domain_part_brackets="${COLOURS[7]}[${COLOURS[10]}$domain_part${COLOURS[7]}]${COLOURS[10]}"
	port_part_brackets="${COLOURS[7]}[${COLOURS[10]}$port_part${COLOURS[7]}]${COLOURS[10]}"

	# join all the parts together
	ssh_line_data="$warning_part_brackets $domain_part_brackets $port_part_brackets"

	# return the ssh line
	echo "$ssh_line_data"

}


# check if we are on a ssh connection
if [ -n "$SSH_CLIENT" ]; then
	# execute the ssh line function
	SSH_LINE="$(ssh_line)\n"
fi

# build the date line
TIME_DATE="${COLOURS[7]}${COLOURS[$TIME_DATE_COLOUR]}$(date +"%Y/%m/%d")${COLOURS[10]}"

# build the time line
TIME_TIME="${COLOURS[7]}${COLOURS[$TIME_LINE_COLOUR]}$(date +"%H:%M:%S")${COLOURS[10]}"

# buid the date brackets
TIME_DATE_LINE="${COLOURS[7]}[${COLOURS[10]}$TIME_DATE${COLOURS[7]}]${COLOURS[10]}"

# build the time brackets
TIME_LINE="${COLOURS[7]}[${COLOURS[10]}$TIME_TIME${COLOURS[7]}]${COLOURS[10]}"

# build the success tab
SUCCESSFULNESS="${COLOURS[7]}[${COLOURS[10]}\$(get_color)\$(print_success)${COLOURS[10]}${COLOURS[7]}]${COLOURS[10]}"

# build the whole time line
TIME="$TIME_DATE_LINE $TIME_LINE $SUCCESSFULNESS"

# build the information line
INFORMATION_LINE="$POWER_COMBO $DIRECTORY_TAB\$(maybe_git)$BASH_SYMBOL_BOLD"

# build the line in which the command will be executed
COMMAND_LINE="$BASH_SYMBOL_BOLD ${COLOURS[7]}>${COLOURS[10]} "

# command line for ps2
COMMAND_LINE_PS2="${COLOURS[7]}  >${COLOURS[10]} "

# the save the success code
PROMPT_COMMAND="SUCCESS_CODE=\$?"

# final ps1 assignment
PS1="\n$SSH_LINE$TIME\n$INFORMATION_LINE\n$COMMAND_LINE"

# assign ps2 as well while we're at it
PS2="$COMMAND_LINE_PS2"
