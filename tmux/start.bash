#!/usr/bin/env bash

set -euo pipefail

DIRECTORY_NOW="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

exec tmux -f "$DIRECTORY_NOW/tmux.conf" "$@"
