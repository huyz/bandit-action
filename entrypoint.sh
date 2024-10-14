#!/usr/bin/env bash

# ./entrypoint.sh . high high ./.venv 0 DEFAULT DEFAULT

# Check for bash 4 for `readarray`
[ "${BASH_VERSINFO:-0}" -ge 4 ] || { echo "${BASH_SOURCE[0]}: ERROR: bash v4+ required." >&2; exit 1; }

UPPERCASE_LEVEL=$(echo "$2" | tr '[:lower:]' '[:upper:]')
case $UPPERCASE_LEVEL in
    LOW)
        LEVEL="-l"
        ;;
    MEDIUM | MID)
        LEVEL="-ll"
        ;;
    HIGH)
        LEVEL="-lll"
        ;;
    *)
        LEVEL=""
        ;;
esac

UPPERCASE_CONFIDENCE=$(echo "$3" | tr '[:lower:]' '[:upper:]')
case $UPPERCASE_CONFIDENCE in
    LOW)
        CONFIDENCE="-i"
        ;;
    MEDIUM | MID)
        CONFIDENCE="-ii"
        ;;
    HIGH)
        CONFIDENCE="-iii"
        ;;
    *)
        CONFIDENCE=""
        ;;
esac

if [ "$4" = "DEFAULT" ]; then
    EXCLUDED_PATHS=()
else
    EXCLUDED_PATHS=(-x "$4")
fi

if [ "$5" = "DEFAULT" ]; then
    EXIT_ZERO=()
else
    EXIT_ZERO=(--exit-zero)
fi

if [ "$6" = "DEFAULT" ]; then
    SKIPS=()
else
    SKIPS=(-s "$6")
fi

if [ "$7" = "DEFAULT" ]; then
    INI_PATH=()
else
    INI_PATH=(--ini "$7")
fi

# select unique files/directories
readarray -t unique_directories <(for dir in "$@"; do echo "$dir"; done | sort -u)

# run bandit on each unique files/directories
for dir in "${unique_directories[@]}"; do
    bandit -r "$dir" $LEVEL $CONFIDENCE "${EXCLUDED_PATHS[@]}" "${EXIT_ZERO[@]}" "${SKIPS[@]}" "${INI_PATH[@]}" -f github
done
