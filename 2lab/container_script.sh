#!/bin/bash
CONTAINER_ID=$(head -c 8 /dev/urandom | od -An -tx4 | tr -d ' \n')
FILE_SEQ=1
DATA_DIR="/common_data"
LOCKFILE="$DATA_DIR/sync_lock"
touch "$LOCKFILE"

while true; do
    exec 7> "$LOCKFILE"
    flock -x 7
    IDX=1
    while [ -e "$DATA_DIR/$(printf '%03d' $IDX)" ]; do
        IDX=$((IDX + 1))
    done
    NEW_FILE="$(printf '%03d' $IDX)"
    echo "$CONTAINER_ID $FILE_SEQ" > "$DATA_DIR/$NEW_FILE"
    FILE_SEQ=$((FILE_SEQ + 1))
    exec 7>&-
    sleep 1
    rm -f "$DATA_DIR/$NEW_FILE"
done