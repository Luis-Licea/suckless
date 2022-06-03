# Set volume to 15% at login to protect hearing.
amixer -D pulse sset Master 15%

# Run picom compositor for blurring windows and rounding corners.
picom -b

# Set wallpaper randomly and change it every 60 seconds.
nowater -d /usr/share/backgrounds/nordic-wallpapers -t 60

# Suckless status bar for dwm.
slstatus &
