#!/bin/bash

WALLPAPERS_DIR="$HOME/Pictures/Wallpaper/"

# Function to build Rofi theme
build_theme() {
    rows=$1
    cols=$2
    icon_size=$3

    echo "element{orientation:vertical;}element-text{horizontal-align:0.5;}element-icon{size:16.5000em;}listview{lines:1;columns:5;}"
}

theme="$HOME/.config/rofi/wallpaper/wallpaper.rasi"

# Command to run Rofi with the built theme
ROFI_CMD="rofi -dmenu -i -show-icons -theme-str $(build_theme 3 5 6) -theme ${theme}"

# Listing wallpapers without file extensions
choice=$(\
    ls --escape "$WALLPAPERS_DIR" | \
        while read A; do \
            name_without_ext=$(basename "$A" | sed 's/\.[^.]*$//'); \
            echo -en "$name_without_ext\x00icon\x1f$WALLPAPERS_DIR/$A\n"; \
        done | \
        $ROFI_CMD -p "󰸉  Wallpaper" \
)

# Find the selected wallpaper and its full path by matching the name with extension
if [ -n "$choice" ]; then
    selected_wallpaper=$(find "$WALLPAPERS_DIR" -type f -name "$choice.*")

    # If wallpaper is found, set the wallpaper and apply the theme
    if [ -n "$selected_wallpaper" ]; then
        swww img -t any --transition-bezier 0.0,0.0,1.0,1.0 --transition-duration 1 --transition-step 255 --transition-fps 100 "$selected_wallpaper" && \
        ln -sf "$selected_wallpaper" ~/Pictures/CurrentWall/current.wall
        wal -i "/home/motria/Pictures/CurrentWall/current.wall" -n
    fi
fi

exit 0
