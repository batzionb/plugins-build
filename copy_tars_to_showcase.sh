#!/bin/bash

usage() {
    echo "Usage: $0 [-s <showcase_directory>] [-b <backend_tar_file>] [-f <frontend_tar_file>] <name>"
    exit 1
}

SHOWCASE_DIR="../backstage-showcase"
BACKEND_TAR=""
FRONTEND_TAR=""

while getopts ":s:b:f:" opt; do
  case $opt in
    s) SHOWCASE_DIR="$OPTARG"
    ;;
    b) BACKEND_TAR="$OPTARG"
    ;;
    f) FRONTEND_TAR="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
        usage
    ;;
  esac
done
shift $((OPTIND -1))

if [ $# -ne 1 ]; then
    usage
fi

NAME="$1"

if [ -n "$BACKEND_TAR" ]; then
    BACKEND_DIR=$(mktemp -d)
    tar -xf "$BACKEND_TAR" -C "$BACKEND_DIR"
fi

if [ -n "$FRONTEND_TAR" ]; then
    FRONTEND_DIR=$(mktemp -d)
    tar -xf "$FRONTEND_TAR" -C "$FRONTEND_DIR"
fi

SCRIPT_DIR=$(dirname "$0")
GENERATED_SCRIPT="$SCRIPT_DIR/copy_to_showcase.sh"

# Call the generated script with optional arguments
if [ -n "$SHOWCASE_DIR" ]; then
    if [ -n "$BACKEND_TAR" ] && [ -n "$FRONTEND_TAR" ]; then
        "$GENERATED_SCRIPT" -b "$BACKEND_DIR/package" -f "$FRONTEND_DIR/package" -s "$SHOWCASE_DIR" "$NAME"
    elif [ -n "$BACKEND_TAR" ]; then
        "$GENERATED_SCRIPT" -b "$BACKEND_DIR/package" -s "$SHOWCASE_DIR" "$NAME"
    elif [ -n "$FRONTEND_TAR" ]; then
        "$GENERATED_SCRIPT" -f "$FRONTEND_DIR/package" -s "$SHOWCASE_DIR" "$NAME"
    else
        "$GENERATED_SCRIPT" -s "$SHOWCASE_DIR" "$NAME"
    fi
else
    if [ -n "$BACKEND_TAR" ] && [ -n "$FRONTEND_TAR" ]; then
        "$GENERATED_SCRIPT" -b "$BACKEND_DIR/package" -f "$FRONTEND_DIR/package" "$NAME"
    elif [ -n "$BACKEND_TAR" ]; then
        "$GENERATED_SCRIPT" -b "$BACKEND_DIR/package" "$NAME"
    elif [ -n "$FRONTEND_TAR" ]; then
        "$GENERATED_SCRIPT" -f "$FRONTEND_DIR/package" "$NAME"
    fi
fi

rm -rf "$BACKEND_DIR" "$FRONTEND_DIR"
