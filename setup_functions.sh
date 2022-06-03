#!/usr/bin/env bash

# When using a session manager such as lightDM, use this function to add DWM to
# the list of sessions, and to configure the DWM X session.
emplace_session() {
    XSESSIONS='/usr/share/xsessions'
    xsession_file='dwm.desktop'
    xsession_config='.xsession'
    xsession_resources='.Xresources'

    echo "Creating config links."
    ln $xsession_file $XSESSIONS/$xsession_file
    ln $xsession_config ~/$xsession_config
    ln $xsession_resources ~/$xsession_resources

    echo "Applying the resource settings."
    xrdb -merge ~/.Xresources
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

        echo "Creating picom config folder."
        picom_config_dir=~/.config/picom
        mkdir "$picom_config_dir"

        echo "Creating config file links."
        picom_config=picom.conf
        ln $picom_config $picom_config_dir/$picom_config

        echo "Running picom"
        picom -b
    fi
}

install nowater() {
    # Install nowater wallpaper manager.
    yaourt -S nowater
}

arch_install=(
    feh # Image viewer and background image setter.
    picom # Needed to enable window transparency.
    nowater # A CLI tool that sets wallpapers or live wallpapers.
)


install_wallpapers() {

    # List of wallpapers to install.
    wallpapers=(
        # cutetifsh-wallpapers
        # elementary-wallpapers
        # ukui-wallpapers
        nordic-wallpapers # saved in /usr/share/backgrounds/nordic-wallpapers/
    )

    # Install every wallpaper package.
    for wallpaper in "${wallpapers[@]}"; do
        # Get wallpaper version.
        wallpaper_is_installed=$(pacman -Q $wallpaper)

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
    install_nowater
    install_picom
}
