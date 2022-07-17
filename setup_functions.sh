#!/usr/bin/env bash

# When using a session manager such as lightDM, use this function to add DWM to
# the list of sessions, and to configure the DWM X session.
emplace_session() {
    XSESSIONS='/usr/share/xsessions'
    WAYSESSIONS='/usr/share/wayland-sessions'
    xsession_file='dwm.desktop'
    waysession_file='dwl.desktop'

    echo "Creating X session links."
    ln "$xsession_file" "$XSESSIONS/$xsession_file"

    echo "Creating Wayland session links."
    ln "$waysession_file" "$WAYSESSIONS/$waysession_file"

    echo "Applying the resource settings."
    if [ -f "$HOME/.Xresources" ]; then
        xrdb -merge /.Xresources
    fi
}

# The profile file contains custom path entries such as .local/bin needed by
# dmenu. These path entries cannot be easily added to /etc/environment and do
# not work for dmenu when they are added to .bashrc or .zshrc.
emplace_profile() {
    echo "Creating profile links."
    sudo ln profile /etc/profile
}

# Install all the suckless programs.
install_suckless() {
    # Suckless directories.
    directories=(
        dmenu
        dwm
        st
    )

    # Go into each directory and install the program.
    for directory in "${directories[@]}"; do
        cd "$directory" || exit
        sudo make clean install
        cd ..
    done
}

install_picom() {
    # Define picom package to install.
    picom='picom-jonaburg-git'

    # Get picom version.
    picom_is_installed=$(pacman -Q $picom)

    # Install picom compositor if it is not installed.
    if [[ "$picom_is_installed" ]]; then
        echo "$picom_is_installed is installed."
    else
        echo "Installing picom."
        yaourt -S $picom
    fi
}

install_nowater() {
    # Install nowater wallpaper manager.
    yaourt -S nowater
}

install=(
    feh                 # Image viewer and background image setter.
    picom-jonaburg-git  # Needed to enable window transparency.
    nowater             # A CLI tool that sets wallpapers or live wallpapers.
    xorg-xev            # Print contents of X events such as key codes.
    dunst               # Customizable and lightweight notification-daemon
)


install_wallpapers() {

    # List of wallpapers to install.
    wallpapers=(
        nordic-wallpapers # saved in /usr/share/backgrounds/nordic-wallpapers/
    )

    # Install every wallpaper package.
    for wallpaper in "${wallpapers[@]}"; do
        # Get wallpaper version.
        wallpaper_is_installed=$(pacman -Q "$wallpaper")

        # Install wallpaper if it is not installed.
        if [[ "$wallpaper_is_installed" ]]; then
            echo "$wallpaper is installed."
        else
            echo "Installing wallpaper."
            yaourt -S "$wallpaper"
        fi
    done

}

# Install everything.
setup() {
    install_suckless
    emplace_session
    emplace_profile
    install_nowater
    install_picom
}

check_differences() {

    # Create an associative array of files and their respective
    # paths.
    declare -A file2path
    file2path[dwm.desktop]=/usr/share/xsessions/dwm.desktop
    file2path[profile]=/etc/profile

    # Iterate thru every file.
    for file in "${!file2path[@]}"; do
        # Store differences between the files.
        differences=$(diff "$file" "${file2path[$file]}")

        # If file already exists and the files are not different:
        if [ -f "${file2path[$file]}" ] && ! [ "$differences" ]; then
            echo "$file exists and is up to date."

            # Create soft link; ask before replacing existing file.
            ln --interactive "$file" "${file2path[$file]}"
            echo "$HOME/$file link set."

        elif [ "$differences" ]; then
            echo "${file2path[$file]} exists, but incoming file (top) differs from existing one (bottom)"
            echo "$differences"
        fi
    done
}

check_differences
