#!/usr/bin/env bash

# Dependencies:
# 1) The folder suckless-wallpapers must exist.

# Source folder.
source_dir=suckless-wallpapers
# Destination folder.
wallpaper_dir=/usr/share/backgrounds/

copy_wallpapers() {
    # If the wallpaper folder exists:
    if [ -d "$wallpaper_dir" ]; then
        # Copy wallpapers to the folder.
        sudo cp -r "$source_dir" "$wallpaper_dir" || exit 1

        # Notify user the folder was moved successfully.
        echo "Copied $source_dir"
    else
        echo "Folder does not exist: $wallpaper_dir"
    fi
}

copy_wallpapers
