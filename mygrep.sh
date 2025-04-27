#!/bin/bash

usage() {
    echo "Usage: $0 [-n] [-v] search_string filename"
    exit 1
}

if [[ "$1" == "--help" ]]; then
    usage
fi

if [[ $# -lt 2 ]]; then
    echo "Error: Missing arguments."
    usage
fi

show_line_numbers=false
invert_match=false

# Start parsing options
while getopts "nv" option; do
    case "$option" in
        n) show_line_numbers=true ;;
        v) invert_match=true ;;
        *) echo "Unknown option: -$option"; usage ;;
    esac
done

# Shift past options
shift $((OPTIND - 1))

# After options, there should be search string and file
if [[ $# -lt 2 ]]; then
    echo "Error: Search string or filename missing."
    usage
fi

search="$1"
file="$2"

# Validate file existence
if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found."
    exit 1
fi

line_number=0
while IFS= read -r line; do
    line_number=$((line_number + 1))
    
    # Check for match (case-insensitive)
    if echo "$line" | grep -i -q "$search"; then
        match=true
    else
        match=false
    fi

    # Invert match if -v is set
    if $invert_match; then
        match=! $match
    fi

    # Print the matching line
    if $match; then
        if $show_line_numbers; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"
