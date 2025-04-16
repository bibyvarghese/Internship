#!/bin/bash

WATCHED_DIR="/home/biby/internship"
cd "$WATCHED_DIR"

while true
do
    /usr/bin/inotifywait -r -e modify,create,delete,move . && \
    git add . && \
    git commit -m "Auto-update: $(date +'%Y-%m-%d %H:%M:%S')" && \
    git push origin main
done
