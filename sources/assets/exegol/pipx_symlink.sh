#!/bin/bash

SOURCE_DIR="/root/.local/pipx/venvs/"
DEST_DIR="/root/.local/bin/"

for folder in $SOURCE_DIR*; do
    folder_name=$(basename $folder)
    if [[ -f "$folder/bin/$folder_name" ]]; then
        ln -v -s "$folder/bin/$folder_name" "$DEST_DIR$folder_name"
    fi
done
