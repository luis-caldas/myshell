#!/usr/bin/env bash

# {{{ Colours

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

# }}}
# {{{ Globals

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
EXECUTION_TIME_COLOUR=1
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

# }}}
# {{{ Pre Script

# characters to help count the non printing characters
LIMITERS=( "\001" "\002" )
LIMITERS_ECHO=( "\x01" "\x02" )

# iterate over the raw colors and add the limiters
for (( loop_index = 0; loop_index <= ${#RAW_COLOURS[@]} + 1; loop_index++ )); do
	COLOURS[$loop_index]="${LIMITERS[0]}${RAW_COLOURS[$loop_index]}${LIMITERS[1]}"
	COLOURS_ECHO[$loop_index]="${LIMITERS_ECHO[0]}${RAW_COLOURS[$loop_index]}${LIMITERS_ECHO[1]}"
done

# check if we are on a ssh connection
if [ -n "$SSH_CLIENT" ]; then
	# execute the ssh line function
	SSH_LINE="$(ssh_line)\n"
fi

# id assignment and file path creation
ROOT_PID="$BASHPID"
BASH_ID_FILE_PATH="/dev/shm/${USER}.bashtime.${ROOT_PID}"

# }}}
# {{{ Dynamic functions (ran at each time the line updates)

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

round_seconds (){

	# variable reasignment
	end_nr="${2}"
	start_nr="${1}"

	# rounds a number to 3 decimal places
	time_difference="$(echo "$end_nr - $start_nr" | bc)"

	# split into integer and float parts
	time_integer="$(echo "$time_difference" | cut -d. -f1)"
	time_float="$(echo "$time_difference" | cut -d. -f2 | head -c 8)"

	# return the number formatted
	printf "%d.%s" "$time_integer" "$time_float"

}

start_time_ps (){
	# places the epoch time in ns into shared memory
	date +%s.%N > "$BASH_ID_FILE_PATH"
}

stop_time_ps (){

	# reads stored epoch time and subtracts from current
	end_time="$(date +%s.%N)"
	start_time="$(cat "$BASH_ID_FILE_PATH")"
	round_seconds "$start_time" "$end_time"

}

# PS1 builder function so newlines can be added as needed
# and not controlled by command substitutions
build_ps1_start() {

	# check if we are running for the first time
	if [ -f "$BASH_ID_FILE_PATH" ]; then

		# stop time line
		stop_time_line="${COLOURS_ECHO[7]}${COLOURS_ECHO[$EXECUTION_TIME_COLOUR]}$(stop_time_ps "$ROOT_PID")${COLOURS_ECHO[10]}"

		# build the stop time line with the brackets
		stop_time_line_brackets="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}$stop_time_line${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"

		# reasign for ease of use
		time_exec="$stop_time_line_brackets\n"

	fi

	# build the date line
	time_date="${COLOURS_ECHO[7]}${COLOURS_ECHO[$TIME_DATE_COLOUR]}$(date +"%Y/%m/%d")${COLOURS_ECHO[10]}"

	# build the time line
	time_time="${COLOURS_ECHO[7]}${COLOURS_ECHO[$TIME_LINE_COLOUR]}$(date +"%H:%M:%S")${COLOURS_ECHO[10]}"

	# buid the date brackets
	time_date_line="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}$time_date${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"

	# build the time brackets
	time_clock="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}$time_time${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"

	# build the success tab
	successfulness="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}$(get_color)$(print_success)${COLOURS_ECHO[10]}${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"

	# build the whole time line
	time_line="$time_date_line $time_clock $successfulness"

	# join the ssh and time exec to the start ps1
	printf "%b" "$time_exec$time_line"

}

# }}}
# {{{ General colours for PS1

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
#JOBS_INFO="${COLOURS[7]}[${COLOURS[10]}\j${COLOURS[7]}]${COLOURS[10]}"

# build the bash version tab
BASH_VERSION="${COLOURS[7]}[${COLOURS[10]}\V${COLOURS[7]}]${COLOURS[10]}"

# build the history and command number tab
#HISTORY_COMMAND="${COLOURS[7]}[${COLOURS[10]}!\!${COLOURS[7]}|${COLOURS[10]}#\#${COLOURS[7]}]${COLOURS[10]}"

# build the information line
INFORMATION_LINE="$POWER_COMBO $DIRECTORY_TAB$(maybe_git)$BASH_SYMBOL_BOLD"

# build the line in which the command will be executed
COMMAND_LINE="$BASH_SYMBOL_BOLD ${COLOURS[7]}>${COLOURS[10]} "

# command line for ps2
COMMAND_LINE_PS2="${COLOURS[7]}  >${COLOURS[10]} "

# }}}
# {{{ Final Assignments

# add time counter to PS0
PS0="\$(start_time_ps ""$ROOT_PID"")"

# the save the success code
PROMPT_COMMAND="SUCCESS_CODE=\$?"

# final ps1 assignment
PS1="\$(build_ps1_start)\n$SSH_LINE$INFORMATION_LINE\n$COMMAND_LINE"

# assign ps2 as well while we're at it
PS2="$COMMAND_LINE_PS2"

# cleanup files on shm
function run_on_exit (){
	rm "/dev/shm/${USER}.bashtime.${ROOT_PID}"
}
trap run_on_exit EXIT

# }}}
