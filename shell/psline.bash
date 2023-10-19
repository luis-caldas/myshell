#!/usr/bin/env bash

# {{{ Colours

##############################
# A simple PS? line for BASH #
##############################

# Create the color array
RAW_COLOURS=(
	"$(tput setaf 1)"  # Red         0
	"$(tput setaf 2)"  # Green       1
	"$(tput setaf 3)"  # Yellow      2
	"$(tput setaf 4)"  # Blue        3
	"$(tput setaf 5)"  # Purple      4
	"$(tput setaf 6)"  # Cyan        5
	"$(tput setaf 7)"  # Gray        6
	"$(tput bold)"     # Bold        7
	"$(tput smul)"     # Underlined  8
	"$(tput blink)"    # Blinking    9
	"$(tput sgr0)"     # Reset       10
)
_TMP_TERM="xterm-pcolor"
# Set the delimiters for setting the title
TITLE_DELIMITERS=(
  "$(TERM="$_TMP_TERM" tput tsl)"      # Title       0
  "$(TERM="$_TMP_TERM" tput fsl)"      # Title End   1
)

# }}}
# {{{ Globals

####################
# Global variables #
####################

# Normal naming variable
SSH_MESSAGE="SSH Connection"

# Colors in numbers
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
COMMAND_CODE_WHAT_COLOUR=6
COMMAND_CODE_BAD_COLOUR=0
NIX_COLOUR=1
BASH_SYMBOL="$"

# Variables that change for root
if [[ $EUID -eq 0 ]]; then
	OLD_USER_NAME=$USER_NAME_COLOUR
	USER_NAME_COLOUR=$HOSTNAME_COLOUR
	HOSTNAME_COLOUR=$OLD_USER_NAME
	BASH_SYMBOL="#"
fi

####################

# }}}
# {{{ Pre Script

# Characters to help count the non printing characters
LIMITERS=( "\001" "\002" )
LIMITERS_ECHO=( "\x01" "\x02" )
HIDERS=( "\[" "\]" )

# Iterate over the raw colors and add the limiters
for (( loop_index = 0; loop_index <= ${#RAW_COLOURS[@]} + 1; loop_index++ )); do
	COLOURS[loop_index]="${LIMITERS[0]}${RAW_COLOURS[loop_index]}${LIMITERS[1]}"
	COLOURS_ECHO[loop_index]="${LIMITERS_ECHO[0]}${RAW_COLOURS[loop_index]}${LIMITERS_ECHO[1]}"
done

# Id assignment and file path creation
ROOT_PID="$BASHPID"
BASH_ID_FILE_PATH="/dev/shm/${USER}.bashtime.${ROOT_PID}"

# }}}
# {{{ Dynamic functions (ran at each time the line updates)

# Function to print the success pipeline
print_success() {

  # Function to set colour based on the code
  set_colour() {

    # Reassign values
    success_now="$1"

    # Start the default colour
    colour_now=''

    # Set colour based on code
    if [ "$success_now" = "0" ]; then
      colour_now="${COLOURS[$COMMAND_CODE_GOOD_COLOUR]}"
    elif [ "$success_now" -lt "64" ]; then
      colour_now="${COLOURS[$COMMAND_CODE_WHAT_COLOUR]}"
    else
      colour_now="${COLOURS[$COMMAND_CODE_BAD_COLOUR]}"
    fi

    # Print error with its colours
	  printf "%b%s%b" "$colour_now" "$success_now" "${COLOURS[10]}"

  }

  # Calculate the total of the array
  total_codes="${#SUCCESS_CODES[@]}"

  # Iterate over all the pipeline processes
  index=0
  while (( index < total_codes )); do

    # Print code with defined colour
    set_colour "${SUCCESS_CODES[index]}"

    # Add separator if needed
    if (( index < ( total_codes - 1 ) )); then
      printf "%b|%b" "${COLOURS_ECHO[7]}" "${COLOURS_ECHO[10]}"
    fi

    # Add to index
    index=$(( index + 1 ))

  done

}

# Build the function that will show the git information if the command in present
maybe_git() {
	# Git command name
	GIT_COMMAND="git"

	# Print trailing space
	printf "%s" " "

	# Check if the command exists and if exists print it
	if type "${GIT_COMMAND}" &> /dev/null; then

		# Extract name of the branch
		GIT_RESULT="$("$GIT_COMMAND" branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"

		if [ -n "$GIT_RESULT" ]; then
			echo -e "${COLOURS[7]}[${COLOURS[$GIT_COLOUR]}$GIT_RESULT${COLOURS[10]}${COLOURS[7]}]${COLOURS[10]} "
		fi

	fi
}

# Generate the shell line if we are on a ssh connection
ssh_line() {

	# Extract data from the ssh variable
	client_ip="$(awk '{ print $1 }' <<< "$SSH_CONNECTION")"
	server_ip="$(awk '{ print $3 }' <<< "$SSH_CONNECTION")"
	client_port="$(awk '{ print $2 }' <<< "$SSH_CONNECTION")"
	server_port="$(awk '{ print $4 }' <<< "$SSH_CONNECTION")"

	# Create the proper parts of the line
	warning_part="${COLOURS_ECHO[7]}${COLOURS_ECHO[$SSH_WARNING_COLOUR]}$SSH_MESSAGE${COLOURS_ECHO[10]}"
	client_ip_part="${COLOURS_ECHO[7]}${COLOURS_ECHO[$SSH_DOMAIN_COLOUR]}${client_ip}${COLOURS_ECHO[10]}"
	server_ip_part="${COLOURS_ECHO[7]}${COLOURS_ECHO[$SSH_DOMAIN_COLOUR]}${server_ip}${COLOURS_ECHO[10]}"
	client_port_part="${COLOURS_ECHO[7]}${COLOURS_ECHO[$SSH_PORT_COLOUR]}${client_port}${COLOURS_ECHO[10]}"
	server_port_part="${COLOURS_ECHO[7]}${COLOURS_ECHO[$SSH_PORT_COLOUR]}${server_port}${COLOURS_ECHO[10]}"

	# Build the brackets around the data
	warning_part_brackets="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}$warning_part${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"

	arrow_part="${COLOURS_ECHO[7]}->${COLOURS_ECHO[10]}"

	client_ip_part_brackets="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}${client_ip_part}${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"
	server_ip_part_brackets="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}${server_ip_part}${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"
	client_port_part_brackets="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}${client_port_part}${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"
	server_port_part_brackets="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}${server_port_part}${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"

	# Join all the parts together
	ssh_line_data="$warning_part_brackets $client_ip_part_brackets $client_port_part_brackets $arrow_part $server_ip_part_brackets $server_port_part_brackets"

	# Return the ssh line
	echo "$ssh_line_data"

}

nix_check() {
	if [ -n "$IN_NIX_SHELL" ]; then
		# Build the nix info line
		nix_info="${COLOURS_ECHO[7]}${COLOURS_ECHO[$NIX_COLOUR]}nix-shell${COLOURS_ECHO[10]}"
		# Create full block
		nix_block="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}$nix_info${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"
		# Echo the info back with space at the end
		echo -e "$nix_block "
	fi
}

round_seconds() {

	# Variable reassignment
	end_nr="${2}"
	start_nr="${1}"

	# Rounds a number to 3 decimal places
	time_difference="$(awk '{print $1-$2}' <<< "$end_nr $start_nr")"

	# Split into integer and float parts
	time_integer="$(echo "$time_difference" | cut -d. -f1)"
	time_float="$(echo "$time_difference" | cut -d. -f2 | head -c 8)"

	# Return the number formatted
	printf "%d.%s" "$time_integer" "$time_float"

}

start_time_ps (){
	# Places the epoch time in ns into shared memory
	date +%s.%N > "$BASH_ID_FILE_PATH"
}

stop_time_ps (){

	# Reads stored epoch time and subtracts from current
	end_time="$(date +%s.%N)"
	start_time="$(cat "$BASH_ID_FILE_PATH")"
	round_seconds "$start_time" "$end_time"

}

# PS1 builder function so newlines can be added as needed
# And not controlled by command substitutions
build_ps1_start() {

	# Check if we are running for the first time
	if [ -f "$BASH_ID_FILE_PATH" ]; then

		# Stop time line
		stop_time_line="${COLOURS_ECHO[7]}${COLOURS_ECHO[$EXECUTION_TIME_COLOUR]}$(stop_time_ps "$ROOT_PID")${COLOURS_ECHO[10]}"

		# Build the stop time line with the brackets
		stop_time_line_brackets="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}$stop_time_line${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"

		# Reassign for ease of use
		time_exec="$stop_time_line_brackets\n"

	fi

	# Build the date line
	time_date="${COLOURS_ECHO[7]}${COLOURS_ECHO[$TIME_DATE_COLOUR]}$(date +"%Y/%m/%d")${COLOURS_ECHO[10]}"

	# Build the time line
	time_time="${COLOURS_ECHO[7]}${COLOURS_ECHO[$TIME_LINE_COLOUR]}$(date +"%H:%M:%S")${COLOURS_ECHO[10]}"

	# Build the date brackets
	time_date_line="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}$time_date${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"

	# Build the time brackets
	time_clock="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}$time_time${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"

	# Build the success tab
	successfulness="${COLOURS_ECHO[7]}[${COLOURS_ECHO[10]}$(print_success)${COLOURS_ECHO[7]}]${COLOURS_ECHO[10]}"

	# Build the whole time line
	time_line="$time_date_line $time_clock $successfulness"

	# Check if we are on a ssh connection
	if [ -n "$SSH_CONNECTION" ]; then
		# Execute the ssh line function
		ssh_line_text="\n$(ssh_line)"
	fi

	# Join the ssh and time exec to the start ps1
	printf "%b" "$time_exec$time_line$ssh_line_text"

}

# }}}
# {{{ General colours for PS1

USER_HOSTNAME="${COLOURS[7]}${COLOURS[$USER_NAME_COLOUR]}\u${COLOURS[10]}${COLOURS[7]}@${COLOURS[$HOSTNAME_COLOUR]}\h${COLOURS[10]}"

# Dir in which the bash is
DIR_NOW="${COLOURS[7]}${COLOURS[$DIRECTORY_COLOUR]}\w${COLOURS[10]}"

# Bash symbol
BASH_SYMBOL_BOLD="${COLOURS[7]}$BASH_SYMBOL${COLOURS[10]}"

# Create the directory tab
DIRECTORY_TAB="${COLOURS[7]}[${COLOURS[10]}$DIR_NOW${COLOURS[7]}]${COLOURS[10]}"

# Build the power combo
POWER_COMBO="${COLOURS[7]}[${COLOURS[10]}$USER_HOSTNAME${COLOURS[7]}]${COLOURS[10]}"

# Build the jobs tab
#JOBS_INFO="${COLOURS[7]}[${COLOURS[10]}\j${COLOURS[7]}]${COLOURS[10]}"

# Build the bash version tab
BASH_VERSION="${COLOURS[7]}[${COLOURS[10]}\V${COLOURS[7]}]${COLOURS[10]}"

# Build the history and command number tab
#HISTORY_COMMAND="${COLOURS[7]}[${COLOURS[10]}!\!${COLOURS[7]}|${COLOURS[10]}#\#${COLOURS[7]}]${COLOURS[10]}"

# Build the information line
INFORMATION_LINE="$POWER_COMBO $DIRECTORY_TAB\$(maybe_git)\$(nix_check)$BASH_SYMBOL_BOLD"

# Build the line in which the command will be executed
COMMAND_LINE="$BASH_SYMBOL_BOLD ${COLOURS[7]}>${COLOURS[10]} "

# Command line for PS2
COMMAND_LINE_PS2="${COLOURS[7]}  >${COLOURS[10]} "

# Set the title
SET_TITLE="${HIDERS[0]}${TITLE_DELIMITERS[0]}[\h] $BASH_SYMBOL \w${TITLE_DELIMITERS[1]}${HIDERS[1]}"
# TODO add subtitle as path on gnome-console

# }}}
# {{{ Final Assignments

# Add time counter to PS0
PS0="\$(start_time_ps ""$ROOT_PID"")"

# the save the success code
PROMPT_COMMAND="SUCCESS_CODES=(\"\${PIPESTATUS[@]}\")"

# Final PS1 assignment
PS1="\$(build_ps1_start)\n$INFORMATION_LINE\n$COMMAND_LINE$SET_TITLE"

# Assign PS2 as well while we're at it
PS2="$COMMAND_LINE_PS2"

# Cleanup files on SHM
function run_on_exit () {
	[ -e "$BASH_ID_FILE_PATH" ] && rm "$BASH_ID_FILE_PATH"
}
trap run_on_exit EXIT

# }}}
