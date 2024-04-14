#!/bin/bash

usage() {
    echo "Usage: $0 [-b <backend_directory>] [-f <frontend_directory>] [-s <showcase_directory>] <plugin_name>"
    exit 1
}

SHOWCASE_DIR="../backstage-showcase"

while getopts ":b:f:s:" opt; do
  case $opt in
    b) BACKEND_DIR="$OPTARG"
    ;;
    f) FRONTEND_DIR="$OPTARG"
    ;;
    s) SHOWCASE_DIR="$OPTARG"
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

if [ -n "$BACKEND_DIR" ]; then
    rm -rf "$SHOWCASE_DIR/dynamic-plugins-root/janus-idp.$NAME-backend"
    mkdir -p "$SHOWCASE_DIR/dynamic-plugins-root/janus-idp.$NAME-backend"
    cp -r "$BACKEND_DIR"/* "$SHOWCASE_DIR/dynamic-plugins-root/janus-idp.$NAME-backend"
fi

if [ -n "$FRONTEND_DIR" ]; then
    rm -rf "$SHOWCASE_DIR/dynamic-plugins-root/janus-idp.$NAME"
    mkdir -p "$SHOWCASE_DIR/dynamic-plugins-root/janus-idp.$NAME"
    cp -r "$FRONTEND_DIR"/* "$SHOWCASE_DIR/dynamic-plugins-root/janus-idp.$NAME"
fi
