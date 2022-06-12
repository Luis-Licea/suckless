# Set volume to 15% at login to protect hearing.
amixer -D pulse sset Master 14%

# Run picom compositor for blurring windows and rounding corners.
picom -b

# Set wallpaper randomly and change it every 60 seconds.
nowater -d /usr/share/backgrounds/nordic-wallpapers -t 60

# Suckless status bar for dwm.
slstatus &

# Mount drive.
udisksctl mount -b /dev/sdb1

# Run fcitx5 in the background as a daemon for keyboard switching.
fcitx5 -d

# Run dunst as a notification daemon.
dunst &

# Search for devices in the network and re-establish connections.
kdeconnect-cli --refresh

