#!/usr/bin/env bash
# Argument-parsing template using the built-in `getopts` (short options).
# Handles: flags (-v), options with values (-o file), -h help, bad usage.
# getopts only does SHORT options; for long options (--verbose) use a manual
# while/case loop or the `getopt` utility. Reference:
#   ../../references/bash/functions.md  ../../references/bash/test-and-conditionals.md

set -euo pipefail

usage() {
	cat <<-EOF
		Usage: ${0##*/} [-v] [-o OUTFILE] [-n NAME] ARG...
		  -o FILE   write output to FILE (default: stdout)
		  -n NAME   name to use (default: world)
		  -v        verbose
		  -h        show this help
	EOF
}

verbose=0
outfile=""
name="world"

# Leading ':' = silent error mode (we report errors ourselves).
# A letter followed by ':' (o:, n:) takes a value, exposed in $OPTARG.
while getopts ":vo:n:h" opt; do
	case "$opt" in
		v) verbose=1 ;;
		o) outfile="$OPTARG" ;;
		n) name="$OPTARG" ;;
		h) usage; exit 0 ;;
		:) echo "error: -$OPTARG requires a value" >&2; usage; exit 2 ;;
		\?) echo "error: unknown option -$OPTARG" >&2; usage; exit 2 ;;
	esac
done
shift $((OPTIND - 1))   # drop parsed options; "$@" now holds positional args

(( verbose )) && echo "verbose on; name=$name; outfile=${outfile:-<stdout>}" >&2

[[ $# -ge 1 ]] || { echo "error: need at least one ARG" >&2; usage; exit 2; }

for arg in "$@"; do
	printf 'hello %s, processing %s\n' "$name" "$arg"
done
