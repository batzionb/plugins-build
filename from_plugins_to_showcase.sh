#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <pluging name>"
    exit 1
fi

DIR=`dirname $BASH_SOURCE`
$DIR/copy_to_showcase.sh ./plugins/$name-backend/dist-dynamic ./plugins/orchestrator