#!/usr/bin/env bash

# Source folder.
wallpaper_dir=/usr/share/backgrounds/nordic-wallpapers
  Destination folder.
wallpaper_exceptions_dir="$wallpaper_dir"-exceptions
# File with wallpapers to move to exceptions folder.
exceptions_file=nordic_wallpaper_exceptions.txt

move_wallpapers() {
    # Read each line in the exceptions file.
    while read -r wallpaper; do
        # Assign source and destination names.
        wallpaper_path="$wallpaper_dir/$wallpaper"
        wallpaper_exception_path=$wallpaper_exceptions_dir/$wallpaper

        # If the wallpaper exists:
        if [ -f "$wallpaper_path" ]; then
            # Move wallpaper to exceptions folder.
            sudo mv "$wallpaper_path" "$wallpaper_exception_path"

            # Notify user the file was moved successfully.
            echo "Moved $wallpaper"
        else
            echo "Does not exist: $wallpaper"
        fi
    done < $exceptions_file
}
# If source directory exists and exceptions directory does not exist:
if [  -d $wallpaper_dir  ] && ! [ -d $wallpaper_exceptions_dir ]; then
    # Create exceptions directory.
    sudo mkdir $wallpaper_exceptions_dir

# If source directory does not exist:
elif ! [  -d $wallpaper_dir  ]; then
    # Warn user and exit.
    echo "Folder does not exist. Install wallpapers first."
    exit
fi

# If source and exceptions directory exists:
if [ -d $wallpaper_dir ] && [ -d $wallpaper_exceptions_dir ]; then
    # Move exceptions to exceptions directory.
    move_wallpapers
fi
