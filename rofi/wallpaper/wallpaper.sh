#!/bin/bash
WALLPAPERS_DIR="$HOME/Pictures/Wallpaper/"
THUMBNAIL_DIR="$WALLPAPERS_DIR/.thumbnails"

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

# Create thumbnail directory if it doesn't exist
mkdir -p "$THUMBNAIL_DIR"

# Listing wallpapers and handling video thumbnails
choice=$(
ls --escape "$WALLPAPERS_DIR" | 
while read A; do 
    # Skip directories (like our hidden .thumbnails folder)
    if [ -d "$WALLPAPERS_DIR/$A" ]; then continue; fi

    name_without_ext=$(basename "$A" | sed 's/\.[^.]*$//') 
    file_path="$WALLPAPERS_DIR/$A"
    icon_path="$file_path"

    # If the file is a video, generate/use a thumbnail for Rofi
    if [[ "$A" == *.mkv || "$A" == *.mp4 || "$A" == *.webm || "$A" == *.gif ]]; then
        thumb_path="$THUMBNAIL_DIR/${A}.jpg"
        
        # Generate thumbnail if it hasn't been created yet
        if [ ! -f "$thumb_path" ]; then
            # Grabs a frame at 10% into the video, size 256px
            ffmpegthumbnailer -i "$file_path" -o "$thumb_path" -s 256 -t 10 -c jpeg >/dev/null 2>&1
        fi
        
        # Tell Rofi to use the generated thumbnail
        icon_path="$thumb_path"
    fi

    # Pass the name, and the correct icon path to Rofi
    echo -en "$name_without_ext\x00icon\x1f$icon_path\n" 
done | 
    $ROFI_CMD -p "󰸉 Wallpaper" 
)

# Find the selected wallpaper and its full path
if [ -n "$choice" ]; then
    selected_wallpaper=$(find "$WALLPAPERS_DIR" -maxdepth 1 -type f -name "$choice.*" -print -quit)

    if [ -n "$selected_wallpaper" ]; then
        # 1. Kill old instances
        killall mpvpaper 2>/dev/null
        
        # 2. Update symlink
        ln -sf "$selected_wallpaper" ~/Pictures/CurrentWall/current.wall
        
        # 3. Update colors
        wal -i "$HOME/Pictures/CurrentWall/current.wall" -n
        
        # 4. Launch mpvpaper in background
        mpvpaper -o "no-audio --loop-playlist shuffle" HDMI-A-3 "$selected_wallpaper" &
        disown
    fi
fi

exit 0